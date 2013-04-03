Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.default_strategies :forum_auth, :cookie
  manager.failure_app = SessionsController
end

# Setup Session Serialization
#class Warden::SessionSerializer
#  def serialize(record)
#    [record.class.name, record.id]
#  end
#
#  def deserialize(keys)
#    klass, id = keys
#    klass.where(id: id).first
#  end
#end

Warden::Strategies.add :forum_auth, Forum::Auth

Warden::Strategies.add(:cookie) do
  def valid?
    cookies['pass_hash']
  end

  def authenticate!
    user = User.find_by_member_login_key cookies['pass_hash']
    if user.present? and user.member_login_key_expire > Time.now.to_i
      success! user
    else
      fail!
    end
  end
end

Warden::Manager.after_authentication do |user, auth, opts|
  auth.env['action_dispatch.cookies']['pass_hash'] = if Time.now.to_i > user.member_login_key_expire
                                                       token = user.generate_remember_token
                                                       token['domain'] = '.' + auth.env['HTTP_HOST']
                                                       token
                                                     else
                                                       {value: user.member_login_key, expires: Time.at(user.member_login_key_expire), domain: '.' + auth.env['HTTP_HOST']}
                                                     end
  auth.env['action_dispatch.cookies']['member_id'] = {value: user.id, expires: 1.year.from_now, domain: '.' + auth.env['HTTP_HOST']}
end

Warden::Manager.before_logout do |user, auth, opts|
  auth.env['action_dispatch.cookies']['pass_hash'] = {expires: 1.day.ago}
end
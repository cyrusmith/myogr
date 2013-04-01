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
    cookies['user.remember.token']
  end

  def authenticate!
    user = User.find_by_member_login_key cookies['user.remember.token']
    if user.present? and user.member_login_key_expire > Time.now.to_i
      success! user
    else
      fail!
    end
  end
end

Warden::Manager.after_authentication do |user, auth, opts|
  auth.env['action_dispatch.cookies']['user.remember.token'] = if Time.now.to_i > user.member_login_key_expire
                                                                 user.generate_remember_token
                                                               else
                                                                 {value: user.member_login_key, expires: Time.at(user.member_login_key_expire)}
                                                               end

  #cookie_hash[:domain]='.forum.ogromno.ru'
  #auth.env['action_dispatch.cookies']['pass_hash'] = cookie_hash
  #auth.env['action_dispatch.cookies']['member_id'] = {value: user.id, expired: 1.year.from_now, domain: '.forum.ogromno.ru'}
end

Warden::Manager.before_logout do |user, auth, opts|
  auth.env['action_dispatch.cookies']['user.remember.token'] = {expires: 1.day.ago}
end

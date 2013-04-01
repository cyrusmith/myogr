Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.default_strategies :cookie, :forum_auth
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
  cookie_hash = user.generate_remember_token
  auth.env['action_dispatch.cookies']['user.remember.token'] = cookie_hash # sets its remember_token attribute to some large random value and returns the value
  cookie_hash[:domain]='.forum.ogromno.ru'
  auth.env['action_dispatch.cookies']['pass_hash'] = cookie_hash
  auth.env['action_dispatch.cookies']['member_id'] = {value: user.id, expired: 1.year.from_now, domain: '.forum.ogromno.ru'}
end

Warden::Manager.before_logout do |user, auth, opts|
  user.update_attribute :member_login_key, nil
end

Warden::Strategies.add :forum_auth, Forum::Auth
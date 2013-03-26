Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.default_strategies :forum_auth
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

# Declare your strategies here
#Warden::Strategies.add(:forum_auth)
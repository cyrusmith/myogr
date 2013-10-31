module Notificator
  include InstanceMethods

  def self.included(model)
    model.extend(Notificator::ClassMethods)
    model.extend(self)
  end

  def self.configure(&block)
    yield(configuration)
    configuration
  end

  def self.configuration
    @_configuration ||= Notificator::Configuration.new
  end

  def self.reset_configuration!
    @_configuration = nil
  end

end
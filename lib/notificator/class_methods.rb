module Notificator
  module ClassMethods

    def configure(&block)
      yield(configuration)
      configuration
    end

    def configuration
      Notificator.configuration
    end

    def reset_configuration!
      Notificator.reset_configuration!
    end

  end
end
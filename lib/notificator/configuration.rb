module Notificator
  class Configuration
    attr_accessor :notification_types
    attr_accessor :default_type

    def initialize
      @notification_types = {}
      @default_type = nil
    end


    def [](option)
      __send__(option)
    end
  end
end
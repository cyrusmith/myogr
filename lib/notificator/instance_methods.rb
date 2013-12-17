module Notificator
  module InstanceMethods
    def notify(type=nil, text, options)
      options = options || {}
      type = self.class.configuration.default_type if type.nil?
      class_name = self.class.configuration.notification_types[type.to_sym]
      if class_name.present? then
        logger.info "Sending #{type} notification for user #{self.id}"
        class_name.notify self, text.html_safe, options
      else
        raise NotificationTypeError.new(type)
      end
    end

    def method_missing(sym, *args)
      if sym.to_s =~ /^notify_via_(\w+)$/
        if $1.to_sym.eql? :all
          exisiting_types = self.class.configuration.notification_types
          exisiting_types.each_key { |type| delay.notify type, args[0], args[1] }
        else
          notification_types = $1.split '_and_'
          notification_types.each do |type|
            delay.notify type, args[0], args[1]
          end
        end
      else
        super
      end
    end
  end

  class NotificationTypeError < StandardError
    def initialize(type)
      super "Notification type #{type} doesn't exist. Add type description to the notification initializer."
    end
  end
end
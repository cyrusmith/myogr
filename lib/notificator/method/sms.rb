module Notificator
  module Method
    class Sms
      def self.notify(recipient, text, options={})
        puts 'SMS'
      end
    end
  end
end
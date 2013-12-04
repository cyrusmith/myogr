module Notificator
  module Method
    class Email
      def self.notify(recipient, text, options={})
        puts 'Email notification'
      end
    end
  end
end
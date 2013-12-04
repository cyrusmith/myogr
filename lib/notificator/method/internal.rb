module Notificator
  module Method
    class Internal
      class << self
        def notify(recipient, text, options={})
          Notification.create!(text: text, user_id: recipient.id)
        end
      end
    end
  end
end
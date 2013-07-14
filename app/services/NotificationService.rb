class NotificationService

  def initialize(user_id)
    @user_id = user_id
  end

  def get_all
    Notification.find_by_user_id(@user_id).all
  end

  def get(message_id)

  end

  def send(message, type, is_permanent=false)
    Notification.create user_id: @user_id, message: message, type: type.to_sym, is_permanent: is_permanent
  end

  def read(message_id)
    Notification.find(message_id).update_attribute(:is_viewed, true)
  end

  def read_all
    Notification.find_by_user_id(@user_id).each{|notification| notification.update_attribute :is_viewed, true}
  end

  def self.send_all(message, type, is_permanent=false)
    User.all.each do |user|
      NotificationService.new(user.id).send(message, type, is_permanent)
    end
  end

end
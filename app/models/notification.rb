class Notification < ActiveRecord::Base
  include Tenacity

  attr_accessible :is_read, :text, :type, :user_id

  t_belongs_to :user

  validates_presence_of :text, :user_id

  scope :read, where(is_read: true)
  scope :unread, where(is_read: false)

  def read?
    is_read
  end

end

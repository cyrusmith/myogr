class Notification < ActiveRecord::Base
  include Tenacity

  attr_accessible :text, :icon, :user_id

  t_belongs_to :user

  validates_presence_of :text, :user_id

  default_scope order('is_read ASC, created_at DESC')
  scope :read, where(is_read: true)
  scope :unread, where(is_read: false)

  def read?
    is_read
  end

  def read
    write_attribute :is_read, true
    save
  end

end

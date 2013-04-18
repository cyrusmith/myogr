class Schedule
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :date, type: Date
  field :is_day_off, type: Boolean, default: false

  #TODO if set ony time it will be applied to current day. For example, schedule.till = '11:00' will set current date + 11 hours
  field :from, type: Time
  field :till, type: Time

  attr_accessible :date, :is_day_off, :from, :till

  validates_presence_of :date

  def day_off?
    self.is_day_off
  end

end

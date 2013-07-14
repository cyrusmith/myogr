class Schedule < ActiveRecord::Base
  belongs_to :extension, polymorphic: true
  attr_accessible :date, :is_day_off, :from, :till

  validates_presence_of :date

  def day_off?
    self.is_day_off
  end

end

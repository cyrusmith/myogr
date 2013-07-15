class Schedule < ActiveRecord::Base
  attr_accessible :date, :is_day_off, :from, :till

  validates_presence_of :date

  belongs_to :extension, polymorphic: true

  def day_off?
    self.is_day_off
  end

end

class Address < ActiveRecord::Base

  before_save :set_location

  attr_accessible :city, :district, :street

  belongs_to :addressable, polymorphic: true

  def short_address
    "#{self.street}"
  end

  def full_address
    "#{self.city}, #{self.street}"
  end

  def set_location
    #TODO запрос по адресу и городу
  end

end

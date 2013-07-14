class Address < ActiveRecord::Base

  before_save :set_location

  belongs_to :addressable, polymorphic: true

  attr_accessible :city, :district, :street

  def to_s
    "#{self.street}"
  end

  def full_address
    "#{self.city}, #{self.street}"
  end

  def set_location
    #TODO запрос к яндексу по адресу и городу
  end

end

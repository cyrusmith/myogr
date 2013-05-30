class Address
  include Mongoid::Document

  before_save :set_location

  field :city, type: String
  field :district, type: String
  field :street, type: String
  field :location, type: Array

  embedded_in :distribution_point
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

#encoding: utf-8
class Address < ActiveRecord::Base

  before_save :set_location

  attr_accessible :city, :district, :street

  belongs_to :addressable, polymorphic: true

  delegate :to_s, to: :full_address

  def short_address
    "ул.#{self.street}"
  end

  def full_address
    "г.#{self.city}, ул.#{self.street}"
  end

  def set_location
    #TODO запрос по адресу и городу
  end

end

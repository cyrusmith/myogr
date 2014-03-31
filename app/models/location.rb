#encoding: utf-8
class Location < ActiveRecord::Base

  after_validation :reverse_geocode, :if => :has_coordinates
  after_validation :geocode, :if => :has_location, :unless => :has_coordinates

  attr_accessible :city, :district, :street, :latitude, :longitude

  belongs_to :addressable, polymorphic: true

  delegate :to_s, to: :full_address

  geocoded_by :full_address

  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      obj.city   = geo.city.empty? ? geo.data['GeoObject']['metaDataProperty']['GeocoderMetaData']['AddressDetails']['Country']['AdministrativeArea']['SubAdministrativeArea']['Locality']['LocalityName'] : geo.city
      obj.street = geo.data['GeoObject']['name'] || geo.address
    end
  end

  def short_address
    "#{self.street}"
  end

  def full_address
    result = "г.#{self.city}"
    result += ", #{self.street}" if self.street
    result
  end

  def has_coordinates
    self.latitude && self.longitude ? true : false
  end

  def has_location
    self.city && self.street ? true : false
  end

end

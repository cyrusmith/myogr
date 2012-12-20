class PromoPlace
  include Mongoid::Document
  include Mongoid::Timestamps

  field :key, :type => String
  field :title, :type => String
  field :conditions, :type => String
  field :mime_whitelist, :type => Array
  field :width, :type => Integer
  field :height, :type => Integer
  field :price_per_day, :type => BigDecimal, :default => 0

  validates_presence_of :key, :title, :width, :height, :price_per_day

end

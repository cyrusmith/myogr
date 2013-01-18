class Banner
  include Mongoid::Document
  include Mongoid::Timestamps

  #after_update :scale

  attr_accessible :link, :title, :description, :type, :is_active, :image, :image_cache, :width, :height
  belongs_to :user

  field :link, :type => String
  field :title, :type => String
  field :description, :type => String
  field :type, :type => String
  field :is_active, :type => Boolean, :default => false
  field :activation_time, :type => DateTime
  field :days_active, :type => Integer, :default => 0

  mount_uploader :image, BannerUploader


  validates :link,:presence => true
  validates :title, :presence => true, :length => {:minimum => 3, :maximum => 50}
  validates :type, :presence => true
  #validates :image, :presence => true

  def scale
    self.banner_image.recreate_versions! if width.present?
  end

  def activate
    self.is_active = true
    self.activation_time = Time.now
    save
  end

  def deactivate
    self.is_active = false
    save
  end
end

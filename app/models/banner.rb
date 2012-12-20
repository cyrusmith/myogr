class Banner
  include Mongoid::Document
  include Mongoid::Timestamps

  after_update :scale

  attr_accessible :link, :title, :description, :type, :active?, :banner_image, :banner_image_cache, :width, :height
  belongs_to :user

  field :link, :type => String
  field :title, :type => String
  field :description, :type => String
  field :type, :type => String
  field :active?, :type => Boolean, :default => false
  field :activation_time, :type => DateTime
  field :days_active, :type => Integer, :default => 0

  mount_uploader :banner_image, BannerUploader


  validates :link,:presence => true, :format => {:with => /forum.ogromno.ru/,
                                                 :message => "Only letters allowed"}
  validates :title, :presence => true, :length => {:minimum => 3, :maximum => 50}
  validates :type, :presence => true
  validates :banner_image, :presence => true

  def scale
    banner_image.recreate_versions! if width.present?
  end
end

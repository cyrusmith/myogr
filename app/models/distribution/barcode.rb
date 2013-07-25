class Distribution::Barcode < ActiveRecord::Base

  after_create :set_value

  attr_accessible :creator, :owner

  belongs_to :package_item

  scope :unused, ->(owner) { where(owner: owner, package_item_id: nil) }
  scope :max_value, ->(owner) { where(owner: owner).order('value DESC') }

  def value
    read_attribute :value
  end

  def barcode_string
    '%06d' % self.owner + '%08d' % self.value
  end

  def self.create_batch(owner, creator, quantity=1)
    self.transaction do
      quantity.times do
        Distribution::Barcode.create! owner: owner, creator: creator
      end
    end
  end

  private

  def value=(value)
    write_attribute :value, value
    write_attribute :barcode_string, barcode_string
  end

  def set_value
    self.value = new_value
    self.save
  end

  def new_value
    #TODO подумать, как можно доставать уже использованные штрихк-коды и использовать их снова добавить проверку на уникальность
    max_code = Distribution::Barcode.max_value(self.owner).first
    unless max_code.nil? or max_code.value.nil?
      max_code.value + 1
    else
      1
    end
  end

end
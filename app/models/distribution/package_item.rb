module Distribution
  class PackageItem
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Paranoia

    field :item_id, type: Integer
    field :title, type: String

    has_one :user
    embedded_in :package

    validates_presence_of :item_id

    attr_accessible :item_id

  end
end

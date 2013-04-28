module Distribution
  class Package
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Paranoia

    field :order, type: Integer
    field :state, type: String

    embeds_many :package_items
    has_one :user

    belongs_to :package_list, class_name: 'Distribution::PackageList', inverse_of: :packages

    accepts_nested_attributes_for :package_items
  end
end

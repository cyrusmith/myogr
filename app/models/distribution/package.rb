class Distribution::Package
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :order, type: Integer
  field :state, type: String

  embeds_many :distribution_distributor
  has_one :user

  belongs_to :package_list, class_name: 'Distribution::PackageList', inverse_of: :packages
end

class Distribution::Package
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :order, type: Integer
  field :state, type: String

  belongs_to :package_list, class_name: 'Distribution::PackageList', inverse_of: :packages
end

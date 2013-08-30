module Distribution
  class PackageItemStateTransition < ActiveRecord::Base
    attr_accessible :package_item_id, :event, :from, :to, :created_at

    belongs_to :distribution_package_item, :class_name => 'Distribution::PackageItem'
  end
end
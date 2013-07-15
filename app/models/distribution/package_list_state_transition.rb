module Distribution
  class PackageListStateTransition < ActiveRecord::Base
    belongs_to :distribution_package_list, :class_name => 'Distribution::PackageList'

    attr_accessible :package_list_id, :event, :from, :to, :created_at
  end
end
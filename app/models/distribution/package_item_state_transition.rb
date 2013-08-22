#TODO объединить с package_list_state_transition, сделать polumorphic association
module Distribution
  class PackageItemStateTransition < ActiveRecord::Base
    self.table_name_prefix = 'distribution_'

    attr_accessible :created_at, :event, :from, :to, :package_item_id

    belongs_to :distribution_package_item, :class_name => 'Distribution::PackageItem'
  end
end

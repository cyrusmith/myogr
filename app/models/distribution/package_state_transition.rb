#TODO объединить с package_list_state_transition, сделать polumorphic association
module Distribution
  class PackageStateTransition < ActiveRecord::Base
    self.table_name_prefix = 'distribution_'

    attr_accessible :created_at, :event, :from, :to, :package_id

    belongs_to :distribution_package, :class_name => 'Distribution::Package'
  end
end

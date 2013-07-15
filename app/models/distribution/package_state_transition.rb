#TODO объединить с package_list_state_transition, сделать polumorphic association
class Distribution::PackageStateTransition < ActiveRecord::Base
  attr_accessible :created_at, :event, :from, :to, :package_id

  belongs_to :distribution_package, :class_name => 'Distribution::Package'
end

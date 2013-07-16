class CreateDistributionPackageListStateTransitions < ActiveRecord::Migration
  def change
    create_table :distribution_package_list_state_transitions do |t|
      t.references :package_list
      t.string :event
      t.string :from
      t.string :to
      t.timestamp :created_at
    end
    add_index :distribution_package_list_state_transitions, :package_list_id, name: :package_list_state_tr
  end
end

class CreateDistributionPackageStateTransitions < ActiveRecord::Migration
  def change
    create_table :distribution_package_state_transitions do |t|
      t.references :package
      t.string :event
      t.string :from
      t.string :to
      t.timestamp :created_at
    end
    add_index :distribution_package_state_transitions, :package_id
  end
end

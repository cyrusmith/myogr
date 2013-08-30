class CreateDistributionPackageItemStateTransitions < ActiveRecord::Migration
  def change
    create_table :distribution_package_item_state_transitions do |t|
      t.references :package_item
      t.string :event
      t.string :from
      t.string :to
      t.timestamp :created_at
    end
    add_index :distribution_package_item_state_transitions, :package_item_id, name: :package_item_state_tr
  end
end

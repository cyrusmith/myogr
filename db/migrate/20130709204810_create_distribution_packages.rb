class CreateDistributionPackages < ActiveRecord::Migration
  def change
    create_table :distribution_packages do |t|
      t.integer :order
      t.string :code
      t.string :state
      t.string :distribution_method, default: :at_point
      t.integer :collector_id
      t.date :collection_date
      t.string :document_number
      t.integer :user_id
      t.references :package_list
      t.timestamps
    end
    add_index :distribution_packages, :user_id
    add_index :distribution_packages, :package_list_id
  end
end

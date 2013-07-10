class CreateDistributionPackageLists < ActiveRecord::Migration
  def change
    create_table :distribution_package_lists do |t|
      t.string :state
      t.integer :package_limit
      t.integer :closed_by
      t.references :point
    end
  end
end

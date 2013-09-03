class CreateDistributionBarcodes < ActiveRecord::Migration
  def change
    create_table :distribution_barcodes do |t|
      t.integer :owner
      t.column :value, :integer, default: 0, limit: 8
      t.integer :creator
      t.references :package_item

      t.timestamps
    end
  end
end

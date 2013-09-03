class AddLocationFieldToPackageItemModel < ActiveRecord::Migration
  def change
    change_table :distribution_package_items do |t|
      t.integer :location
      t.string :recieved_from
    end
  end
end

class AddTimestampsToPackageItems < ActiveRecord::Migration
  def change
    change_table :distribution_package_items do |table|
      table.timestamps
    end
  end
end

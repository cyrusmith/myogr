class AddLocationColumnToPackageItem < ActiveRecord::Migration
  def change
    add_column :distribution_package_items, :location, :string
  end
end

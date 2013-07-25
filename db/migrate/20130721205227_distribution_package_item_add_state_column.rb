class DistributionPackageItemAddStateColumn < ActiveRecord::Migration
  def change
    add_column :distribution_package_items, :state, :string
  end
end

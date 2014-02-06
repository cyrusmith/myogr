class AddDistinationColumnToPackages < ActiveRecord::Migration
  def change
    add_column :distribution_packages, :appointment_id, :integer
  end
end

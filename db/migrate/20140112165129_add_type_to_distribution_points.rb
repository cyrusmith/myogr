class AddTypeToDistributionPoints < ActiveRecord::Migration
  def change
    add_column :distribution_points, :type, :string, null: false
    add_column :distribution_points, :autoaccept_point_id, :integer
  end

end
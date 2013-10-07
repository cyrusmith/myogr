class AddPhoneColumnToDistributionPoint < ActiveRecord::Migration
  def change
    add_column :distribution_points, :phone, :string
    change_column_default :distribution_points, :work_schedule, nil
    change_column :distribution_points, :work_schedule, :text
  end
end

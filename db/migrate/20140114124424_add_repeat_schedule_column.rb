class AddRepeatScheduleColumn < ActiveRecord::Migration
  def change
    add_column :distribution_points, :repeat_schedule, :integer, default: 0
  end
end

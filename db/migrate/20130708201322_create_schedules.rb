class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.date :date
      t.boolean :is_day_off, default: false
      t.time :from
      t.time :till
      t.references :extension, polymorphic: true
    end
  end
end

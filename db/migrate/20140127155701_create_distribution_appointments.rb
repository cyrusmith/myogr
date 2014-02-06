class CreateDistributionAppointments < ActiveRecord::Migration
  def change
    create_table :distribution_appointments do |t|
      t.belongs_to :meeting_place
      t.belongs_to :package_list
      t.time :from
      t.time :till
    end
  end
end

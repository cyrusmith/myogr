class CreateMeetingPlaces < ActiveRecord::Migration
  def change
    create_table :distribution_meeting_places do |t|
      t.string :description
    end
  end
end

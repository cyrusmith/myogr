class CreatePointsUsers < ActiveRecord::Migration
  def change
    create_table :points_users do |t|
      t.integer :point_id
      t.integer :employee_id
    end
  end
end

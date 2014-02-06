class RenameLocationColumns < ActiveRecord::Migration
  def change
    change_table :locations do |t|
      t.remove :geo_x
      t.remove :geo_y
      t.float :latitude
      t.float :longitude
    end
  end
end

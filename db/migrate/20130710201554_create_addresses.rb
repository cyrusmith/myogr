class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :city
      t.string :district
      t.string :street
      t.float :geo_x
      t.float :geo_y
      t.references :addressable, polymorphic: true
    end
  end
end

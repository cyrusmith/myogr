class CreateDistributionPackageItems < ActiveRecord::Migration
  def change
    create_table :distribution_package_items do |t|
      t.integer :item_id
      t.string :title
      t.integer :user_id
      t.integer :organizer_id
      t.string :organizer
      #состояние закупки, в тот момент, когда пользователь отправил ее в сборку
      t.string :state_on_creation
      t.boolean :is_collected, default: false
      t.boolean :is_user_participate, default: true
      t.boolean :is_next_time_pickup, default: false
      t.references :package
    end
    add_index :distribution_package_items, :item_id
    add_index :distribution_package_items, :user_id
  end
end

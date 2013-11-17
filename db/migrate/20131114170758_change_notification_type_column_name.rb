class ChangeNotificationTypeColumnName < ActiveRecord::Migration
  def change
    change_table :notifications do |t|
      t.remove :type
      t.string :icon
    end
  end
end

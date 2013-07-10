class CreateDistributionPoints < ActiveRecord::Migration
  def change
    create_table :distribution_points do |t|
      t.string :title
      t.integer :head_user
       #:employees, type: Array подумать, как лучше сделать. По идее тут многие ко многим
      t.integer :default_day_package_limit, default: Distribution::Settings.day_package_limit
      t.string :work_schedule
    end
  end
end

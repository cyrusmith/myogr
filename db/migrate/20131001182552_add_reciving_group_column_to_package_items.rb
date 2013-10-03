class AddRecivingGroupColumnToPackageItems < ActiveRecord::Migration
  def change
    add_column :distribution_package_items, :receiving_group_number, :integer
    add_column :distribution_package_items, :receiver, :string

    #в этой колонке храним, что конкретно у данного заказа не соответствует правилам. 1 - не соответствует упаковка, 2- не соответствует маркировка
    add_column :distribution_package_items, :not_conform_rules, :string
  end
end

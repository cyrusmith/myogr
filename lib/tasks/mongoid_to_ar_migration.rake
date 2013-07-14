namespace :mongoid_to_ar_migration do
  desc 'Move user roles from mongoid to activeRecord'
  task :roles => :environment do
    UserRole.all.each do |userrole|
      userrole.roles.each do |rolename|
        role = Role.find_by_name rolename
        role = Role.create! name: rolename if role.nil?
        role.users << User.find(userrole.user_id)
      end
    end
  end

  desc 'distribution module migration'
  task :distribution => :environment do
    ActiveRecord::Base.transaction do
      Distribution::Point.all.each do |point|
        point_sql = "INSERT INTO distribution_points(title, head_user, default_day_package_limit, work_schedule)
                                             VALUES ( '#{point.title}', #{point.head_user}, #{point.default_day_package_limit}, '#{point.work_schedule}')"
        ActiveRecord::Base.connection.execute point_sql
        point_id = get_last_insert_id
        point_address = point.address
        address_sql = "INSERT INTO addresses(city, district, street, addressable_id, addressable_type)
                                      VALUES('#{point_address.city}', '#{point_address.district}', '#{point_address.street}', #{point_id}, 'Distribution::Point')"
        ActiveRecord::Base.connection.execute address_sql
        point.package_lists.each do |package_list|
          package_list_sql = "INSERT INTO distribution_package_lists(state, package_limit, point_id)
                                                             VALUES ('#{package_list.state}', #{package_list.package_limit}, #{point_id})"
          ActiveRecord::Base.connection.execute package_list_sql
          package_list_id = get_last_insert_id
          schedule_sql = "INSERT INTO schedules(`date`, is_day_off, `from`, `till`, extension_id, extension_type)
                                        VALUES ('#{package_list.date}', #{package_list.day_off? ? 1 : 0}, '#{package_list.from}', '#{package_list.till}', #{package_list_id}, 'Distribution::PackageList')"
          ActiveRecord::Base.connection.execute schedule_sql
          package_list.packages.each do |package|
            user_id = package.user.present? ? package.user.id : 'NULL'
            package_sql = "INSERT INTO distribution_packages(user_id, `order`, `code`, distribution_method, collector_id, collection_date, document_number, package_list_id, state)
                                                    VALUES (#{user_id}, #{package.order}, '#{package.code}', '#{package.distribution_method}', #{package.collector_id.nil? ? 'NULL' : package.collector_id}, '#{package.collection_date}', '#{package.document_number}', #{package_list_id}, '#{package.state}')"
            ActiveRecord::Base.connection.execute package_sql
            package_id = get_last_insert_id
            package.items.each do |item|
              item_sql = "INSERT INTO distribution_package_items(item_id, title, user_id, organizer_id, organizer, state_on_creation, is_collected, is_user_participate, is_next_time_pickup, package_id)
                                                         VALUES (#{item.item_id}, '#{item.title}', #{user_id}, #{item.organizer_id}, '#{item.organizer}', '#{item.state_on_creation}', #{item.is_collected ? 1 : 0}, #{item.is_user_participate ? 1 : 0}, #{item.is_next_time_pickup ? 1 : 0}, #{package_id})"
              ActiveRecord::Base.connection.execute item_sql
            end
          end
        end
      end
    end
  end

  def get_last_insert_id
    result = ActiveRecord::Base.connection.execute 'SELECT LAST_INSERT_ID()'
    result.first[0]
  end

end
namespace :mongoid_to_ar_migration do
  desc 'Move user roles from mongoid to activeRecord'
  task :roles => :environment do
    UserRole.all.each do |userrole|
      userrole.roles.each do |rolename|
        role = Role.find_by_name rolename
        role = Role.create! name:rolename if role.nil?
        role.users << User.find(userrole.user_id)
      end
    end
  end

end
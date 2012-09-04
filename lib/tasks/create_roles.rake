namespace :role do
  desc "Creating Roles"
  task :create_and_save => :environment do
    roles_array = ["user","worker","global_admin","local_admin", "main_local_admin", "business_group_owner" ,"admin_group_owner" ,"admin_group_worker" ,"main_admin_group_owner"]
    roles_array.each do |role_name|
      role = UserRole.new(:role_name=> role_name)
      role.save
    end
  end
end

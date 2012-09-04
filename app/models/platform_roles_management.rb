class PlatformRolesManagement
  #TODO need to be refactor the code
  include Mongoid::Document
  belongs_to :user
  belongs_to :platform_global_admin
  belongs_to :user_role
  belongs_to :platform_local_admin

  def self.assign_global_admin_role(user,global_admin)
    role = UserRole.get_role "global_admin"
    role_management =user.platform_roles_managements.new
    role_management.user_role = role
    role_management.platform_global_admin = global_admin
    role_management.save
  end

  def self.assign_local_admin_role(user,local_admin)
    role = UserRole.get_role "local_admin"
    role_management =user.platform_roles_managements.new
    role_management.user_role = role
    role_management.platform_local_admin = local_admin
    role_management.save
  end

  def assign_user_role user
    role = UserRole.get_role "user"
    role_management =user.platform_roles_managements.new
    role_management.user_role = role
    role_management.save
  end

end

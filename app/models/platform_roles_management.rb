class PlatformRolesManagement
  include Mongoid::Document
  belongs_to :user
  belongs_to :platform_global_admin
  belongs_to :user_role

  def self.assign_global_admin_role(user,global_admin)
    role = UserRole.get_role "global_admin"
    role_management =user.platform_roles_management.new
    role_management.user_role = role
    role_management.platform_global_admin = global_admin
    role_management.save
  end

  def assign_user_role user
    role = UserRole.get_role "user"
    role_management =self.platform_roles_management.new
    role_management.user_role = role
    role_management.save
  end

end

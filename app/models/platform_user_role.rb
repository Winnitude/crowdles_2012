class PlatformUserRole
  include Mongoid::Document
  belongs_to :user
  belongs_to :platform_ga
  belongs_to :platform_role

  #def self.assign_global_admin_role
  #  role = PlatformRole.get_role "global_admin"
  #  user_role=PlatformUserRole.new
  #  user_role.platform_ga
  #end
end

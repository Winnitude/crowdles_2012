class UserRole
  include Mongoid::Document
  field :role_name,  :type => String
  has_many :platform_roles_management

  def self.get_role role
    where(:role_name => role).first
  end
end

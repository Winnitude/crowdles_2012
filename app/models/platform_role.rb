class PlatformRole
  include Mongoid::Document
  field :role_name,  :type => String
  has_many :platform_user_roles

  def self.get_role role
    where(:role_name => role).first
  end
end

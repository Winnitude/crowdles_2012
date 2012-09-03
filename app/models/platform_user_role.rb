class PlatformUserRole
  include Mongoid::Document
  belongs_to :user
  belongs_to :platform_ga
  belongs_to :platform_role
end

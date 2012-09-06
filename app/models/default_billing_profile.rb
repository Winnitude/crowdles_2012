class DefaultBillingProfile
  include Mongoid::Document
  belongs_to :user
  belongs_to :platform_global_admin
  belongs_to :platform_admin_group
end

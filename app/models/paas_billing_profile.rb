class PaasBillingProfile < PlatformBillingProfile
  include Mongoid::Document
  belongs_to :platform_global_admin
  belongs_to :platform_local_admin
end

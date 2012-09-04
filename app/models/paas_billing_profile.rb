class PaasBillingProfile < PlatformBillingProfile
  include Mongoid::Document
  belongs_to :platform_global_admin
end

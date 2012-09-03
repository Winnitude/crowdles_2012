class PlatformBillingProfile < BillingProfile
  include Mongoid::Document
  belongs_to :platform_ga
end

class BillingProfilePaas < PlatformBillingProfile
  include Mongoid::Document
  belongs_to :platform_ga
end

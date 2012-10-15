class BillingProfileDefault < PlatformBillingProfile
  include Mongoid::Document
  belongs_to :user
  belongs_to :platform_ga

end

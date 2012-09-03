class DefaultBillingProfile < BillingProfile
  include Mongoid::Document
  belongs_to :user
  belongs_to :platform_ga

end

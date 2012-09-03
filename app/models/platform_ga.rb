class PlatformGa #will act as base class for the GA related things
  include Mongoid::Document
  has_many :billing_profiles

  def initialize_billing_profiles param
    self.billing_profiles.create(:billing_profile_type => "Default" ,:currency => param[:currency])
    self.billing_profiles.create(:billing_profile_type => "Platform",:currency => param[:currency])
  end
end

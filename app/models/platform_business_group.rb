class PlatformBusinessGroup
  include Mongoid::Document
  belongs_to :platform_admin_group
  has_one :bg_location
  has_one :bg_link
  has_one :bg_profile
  has_one :bg_general_setting
  has_one :bg_term
  has_one :bg_commissions_setting
  field :affiliation_key, :type => String
end

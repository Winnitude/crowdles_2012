class PlatformBusinessGroup
  include Mongoid::Document
  belongs_to :platform_admin_group
  has_one :bg_location
  has_one :bg_link
  #has_one :bg_profile
  has_one :bg_setting
  #has_one :bg_term
  has_one :bg_template
  has_one :bg_content
  has_one :bg_commissions_setting
  has_one :bg_social
  has_one :bg_additional_term
  field :affiliation_key, :type => String

  def set_all_settings
    self.create_bg_location
    self.create_bg_link
    self.create_bg_setting
    self.create_bg_template
    self.create_bg_commissions_setting
    self.create_bg_content
    self.create_bg_social
    self.create_bg_additional_term
  end
end

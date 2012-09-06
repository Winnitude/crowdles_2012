class PlatformAdminGroup
  include Mongoid::Document
  has_one :ag_general_setting
  has_one :ag_profile
  has_one :ga_projects_setting
  has_one :ag_commissions_setting
  has_one :ag_paas_setting
  field :ag_creation_date ,                         :type => Date
  field :ag_expiration_date ,                       :type => Date
  field :ag_deactivation_date ,                     :type => Date
  field :status ,                                   :type => String
end

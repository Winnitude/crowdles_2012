class BgSetting
  include Mongoid::Document
  belongs_to :platform_business_group
  #field :business_group_name,             :type => String
  field :external_projects_allowed,       :type => String
  field :offline_payment_projects_allowed,       :type => String
  field :platform_visibility,       :type => String
  field :projects_visibility,       :type => String
  field :team_visibility,       :type => String
  field :group_url,       :type => String
  field :publication_status,       :type => String
  field :publication_date,       :type => Date

end

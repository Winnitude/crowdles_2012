class AgPaasSetting
  include Mongoid::Document
  belongs_to :platform_admin_group
  field :paas_fees_exemption,     :type => Boolean
end

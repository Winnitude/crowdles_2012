class LaPaasSetting
  include Mongoid::Document
  belongs_to :platform_local_admin
 field :paas_la_commissions,  :type => Float
end

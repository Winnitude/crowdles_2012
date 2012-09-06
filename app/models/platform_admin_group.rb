class PlatformAdminGroup
  include Mongoid::Document
  field :ag_creation_date ,                         :type => Date
  field :ag_expiration_date ,                       :type => Date
  field :ag_deactivation_date ,                     :type => Date
  field :status ,                                   :type => String
end

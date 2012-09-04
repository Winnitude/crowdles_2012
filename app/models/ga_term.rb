class GaTerm
  include Mongoid::Document
  belongs_to :platform_global_admin
  field :user_terms,                          :type => String
  field :project_terms,                       :type => String
  field :worker_terms,                        :type => String
  field :admin_group_terms,                   :type => String
  field :business_group_terms,                :type => String
  field :no_profit_terms,                     :type => String
end

class LaTerm
  include Mongoid::Document
  belongs_to :platform_local_admin
  field :paas_terms_local,                                     :type => String
  field :user_terms,                                           :type => String
  field :project_terms,                                        :type => String
  field :worker_terms,                                         :type => String
  field :admin_group_terms,                                    :type => String
  field :business_group_terms,                                 :type => String
  field :no_profit_terms,                                      :type => String
end

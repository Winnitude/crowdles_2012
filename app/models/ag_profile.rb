class AgProfile
  include Mongoid::Document
  belongs_to :platform_admin_group
  field :admin_group_description ,                  :type => String
  field :admin_group_email ,                        :type => String
  field :first_name ,                               :type => String
  field :last_name ,                                :type => String
  field :company_name ,                             :type => String
  field :country ,                                  :type => String
  field :city ,                                     :type => String
  field :zip_code ,                                 :type => String
  field :state ,                                    :type => String
  field :address ,                                  :type => String
  field :additional_address ,                       :type => String
  field :phone_number ,                             :type => String
end

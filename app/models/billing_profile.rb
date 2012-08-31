class BillingProfile
  include Mongoid::Document
  include Mongoid::Document
  belongs_to :user
  belongs_to :global_admin
  before_save :set_creation_date
  field :billing_profile_type ,        :type => String
  field :creation_date                 ,:type => DateTime
  field :last_modification_date         ,:type => DateTime
  field :currency                     ,:type => String
  field :first_name                     ,:type => String
  field :last_name                       ,:type => String
  field :company_name                     ,:type => String
  field :birth_date                     ,:type => Date
  field :birth_place                     ,:type => String
  field :email                           ,:type => String
  field :telephone_number                  ,:type => String
  field :language                         ,:type => String
  field :vat_number                         ,:type => String
  field :country                          ,:type => String
  field :city                             ,:type => String
  field :zip_code                           ,:type => String
  field :state                             ,:type => String
  field :street1                            ,:type => String
  field :street2                           ,:type => String
  field :contact_first_name                    ,:type => String
  field :contact_last_name                 ,:type => String
  field :contact_telephone_number        ,:type => String
  field :paypal_id                       ,:type => String


  private

  def set_creation_date
    self.creation_date = DateTime.now
    self.last_modification_date = DateTime.now
  end
end
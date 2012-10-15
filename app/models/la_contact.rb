class LaContact
  include Mongoid::Document
  belongs_to :platform_local_admin
  field :contact_first_name,                                   :type => String
  field :contact_last_name,                                    :type => String
  field :contact_email,                                        :type => String
  field :contact_biography,                                    :type => String
  mount_uploader :contact_photo, ImageUploader
end

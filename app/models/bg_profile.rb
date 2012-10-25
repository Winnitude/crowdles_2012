class BgProfile
  include Mongoid::Document
  belongs_to :platform_business_group
  field :bg_slogan,                        :type => String
  field :bg_short_description,             :type => String
  field :bg_group_description,                        :type => String
  field :platform_likes,                        :type => Integer
  field :platform_rate,                        :type => Float
  field :recommended,                        :type => Boolean
  mount_uploader :logo, ImageUploader
  mount_uploader :main_image, ImageUploader
  mount_uploader :image2, ImageUploader
  mount_uploader :image3, ImageUploader
  mount_uploader :image4, ImageUploader
  mount_uploader :image5, ImageUploader
  mount_uploader :image6, ImageUploader
  mount_uploader :main_video, ImageUploader
  mount_uploader :team_image, ImageUploader
  mount_uploader :main_video, ImageUploader


end

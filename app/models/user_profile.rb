class UserProfile
  include Mongoid::Document
  belongs_to :user
  field :privacy , :type => String
  field :first_name , :type => String
  field :last_name , :type => String
  field :nick_name , :type => String
  field :birth_date , :type => Date
  field :gender , :type => String
  field :news_letter_flag , :type => Boolean,:default=>true
  field :language , :type => String
  field :biography , :type => String
  field :video , :type => String
  field :country , :type => String
  field :main_segment , :type => String
  field :old_main_segment , :type => String
  field :fb_image ,                       :type => String
  field :fb_page   ,                       :type => String
  mount_uploader :photo, ImageUploader

  def get_full_name
    first_name = self.first_name + " "
    last_name = self.last_name
    if last_name
      first_name + last_name
    else
      first_name
    end
  end

  def update_fb_details token
    self.first_name = token.extra.raw_info.first_name unless self.first_name.present?
    self.last_name = token.extra.raw_info.last_name unless self.last_name.present?
    self.fb_image = token.info.image
    self.fb_page =   token.extra.raw_info.link
    self.save
  end

end

class UserProfile
  include Mongoid::Document
  belongs_to :user
  field :privacy , :type => String
  field :first_name , :type => String
  field :last_name , :type => String
  field :nick_name , :type => String
  field :birth_date , :type => Date
  field :gender , :type => String
  field :new_letter_flag , :type => Boolean
  field :language , :type => String
  field :biography , :type => String
  field :video , :type => String
  field :country , :type => String
  field :main_segment , :type => String
  field :old_main_segment , :type => String
  #field :photo

  def get_full_name
   first_name = self.first_name + " "
   last_name = self.last_name
    if last_name
      first_name + last_name
    else
      first_name
    end
  end


end

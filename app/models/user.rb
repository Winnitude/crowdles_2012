class User
  include Mongoid::Document
  #  embeds_one :profile
  #  accepts_nested_attributes_for :profile
  #has_one :profile,:dependent => :destroy
  #accepts_nested_attributes_for :profile

  #  before_create :build_profile
  # embeds_many :ideas
  has_one :user_profile
  has_one :user_link
  has_one :user_contact
  has_one :default_billing_profile,  :dependent => :destroy
  has_many :platform_roles_managements
  has_many :platform_local_admins
  has_many :platform_admin_groups
  has_one  :platform_global_admin
  after_create :assign_role_to_user
  #before_create :set_time_and_status
  before_save :accept_terms
  attr_accessible :profile_attributes, :email, :password, :password_confirmation,
                  :remember_me ,:country, :terms_of_service,:is_provider,
                  :is_provider_terms_of_service,:profile,:facebook_id ,:registration_ip ,:status ,:created_at,:language,:is_proprietary_user
  #######################User Login functionality with devise integration############################
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:confirmable ,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  ## Database authenticatable
  field :encrypted_password, :type => String, :null => false, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time
  ## Trackable
  field :sign_in_count,                   :type => Integer, :default => 0
  field :current_sign_in_at,              :type => Time
  field :last_sign_in_at,                 :type => Time
  field :current_sign_in_ip,              :type => String
  field :last_sign_in_ip,                 :type => String
  field :suspended,                       :type => Boolean ,:null => false, :default => false
  field :is_provider_terms_of_service,    :type => Boolean , :default => false
  field :is_provider,                     :type => Boolean ,:null => false, :default => false
  field :role,                            :type=> String

  ## Encryptable
  # field :password_salt, :type => String

  # Confirmable
  field :confirmation_token,              :type => String
  field :confirmed_at,                    :type => Time
  field :confirmation_sent_at,            :type => Time
  field :unconfirmed_email,               :type => String # Only if using reconfirmable
  field :facebook_id,                     :type => String
  field :registration_ip,                 :type => String
  field :status,                          :type => String  , :default => "new"
  field :created_at ,                     :type => DateTime
  field :language ,                       :type => String
  field :is_proprietary_user,             :type => Boolean
  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  ##Type for Single Table Inheritance
  #  field :type,   :type => String

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    #binding.remote_pry
    data = access_token.extra.raw_info
    user = User.where(:facebook_id => data.id).first
    user = User.where(:email => data.email).first  unless user.present?
    if !user.nil?
      if user.status == "new"
        user.confirm!
        user.save!
        profile=user.build_user_profile(:first_name => data["first_name"],:last_name => data["last_name"]).save
      end
      user.update_attributes(:is_provider => true, :facebook_id => data["id"])
      user
    else # Create an user with a stub password.
      user = User.new({:email => data["email"],
                       :password => Devise.friendly_token[0,20],
                       :is_provider => true,
                       :is_proprietary_user => false,
                       #:profile_attributes => {:first_name => data["first_name"],:last_name => data["last_name"]}
                       :facebook_id => data["id"],
                       :created_at => Time.now,
                       :status => "new"
                      })

      user
      #session[:facebook_data] = facebook_data
#      profile=user.build_user_profile(:first_name => data["first_name"],:last_name => data["last_name"])
#      user.confirm!
#      user.save!
#      profile.save!
##      UserMailer.welcome_email(user).deliver if !user.nil?
#      User.where(:email => data.email).first
    end
  end


  #Devise Confirmation settings
  # new function to set the password without knowing the current password used in our confirmation controller.
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end
  # new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  # new function to provide access to protected method unless_confirmed
  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

  def password_required?
    # Password is required if it is being set, but not for new records
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end
  #######################User Login functionality ENDS############################


  field :email,              :type => String
  validates :email,
            :uniqueness => true,
            :email => true
  #
  field :country,            :type => String
  #validates :country,
  #          :presence => true,
  #          :if => :should_not_provider?

  field :terms_of_service,   :type => Boolean
  #validates :terms_of_service,
  #          :acceptance => {:accept => true},
  #          :on => :create,
  #          :if => :should_not_provider?




  def should_not_provider?
    is_provider == false
  end
  def self.create_global_admin_owner param
    user = User.new(:email => param[:admin_email], :password =>param[:password], :password_confirmation => param[:password], :terms_of_service =>true, :country => param[:country], :status => "active")
    user.skip_confirmation!
    user.save!
    user.build_user_profile(:first_name => "Administrator", :country => param[:country] ,:language =>param[:language] ).save
    return user
  end

  def initialize_default_billing_profile param
    billing_profile=self.build_default_billing_profile(:currency => param[:currency] ).save
  end

  def assign_role_to_user
    role = UserRole.get_role "user"
    role_management =self.platform_roles_managements.new
    role_management.user_role = role
    role_management.save
  end
  def accept_terms
    self.is_provider_terms_of_service = true
  end

  def all_roles
    roles = self.platform_roles_managements.includes(:user_role).collect{|i| i.user_role.role_name}
  end

  def is_from_admin_side
    roles = self.all_roles
    roles.include?("global_admin")  ||  roles.include?("local_admin")
  end

  def get_email
    self.email
  end

  def get_full_name
    self.user_profile.get_full_name   rescue nil
  end

  def has_role role
    self.all_roles.include? role
  end

  def fetch_ip_and_country(request)
    logger.info ("inside model method #######################{self.inspect}")
    self.registration_ip = request.ip
    self.country = request.location.country.upcase
    self.country ="INDIA" if self.country.downcase == "reserved" #doing this coz in local(dev environment)  IP is 127.0.0.1 for this country is reserved
    self.set_time_and_status
  end

  def set_time_and_status
    self.created_at = Time.now
    self.status = "new"
    self.is_proprietary_user = true
  end


end



class User < ForumModels
  include Tenacity
  self.table_name = 'ibf_members'

  before_create :create_credential, :create
  after_create :create_extra, :create

  has_one :credential, foreign_key: 'converge_id', readonly: true
  has_one :extra, foreign_key: 'id'
  t_has_many :banners
  t_has_many :records

  attr_accessor :password, :username
  attr_accessible :username, :email, :password, :member_login_key, :member_login_key_expire

  def username=(value)
    self.name = value
    self.members_l_display_name = value
    self.members_l_username = value
    self.members_display_name = value
  end

  #include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable,      , :confirmable
  # :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable
  #
  #
  ### Database authenticatable
  #field :username,           :type => String,   :default => ""
  #field :email,              :type => String,   :default => ""
  #field :encrypted_password, :type => String,   :default => ""
  #field :roles,              :type => Array,    :default => [:user]
  #field :forum_id,           :type => Integer,  :default => 0
  #field :forum_data,         :type => Hash
  #
  #validates_presence_of :username
  #validates_presence_of :email
  #validates_presence_of :encrypted_password
  #
  ### Recoverable
  #field :reset_password_token,   :type => String
  #field :reset_password_sent_at, :type => Time
  #
  ### Rememberable
  #field :remember_created_at, :type => Time
  #
  ### Trackable
  #field :sign_in_count,      :type => Integer, :default => 0
  #field :current_sign_in_at, :type => Time
  #field :last_sign_in_at,    :type => Time
  #field :current_sign_in_ip, :type => String
  #field :last_sign_in_ip,    :type => String
  #
  ### Confirmable
  #field :confirmation_token,   :type => String
  #field :confirmed_at,         :type => Time
  #field :confirmation_sent_at, :type => Time
  #field :unconfirmed_email,    :type => String # Only if using reconfirmable
  #
  ### Lockable
  ## field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  ## field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  ## field :locked_at,       :type => Time
  #
  ### Token authenticatable
  ## field :authentication_token, :type => String
  #attr_accessor :login
  #
  #ROLES = [:user, :verified_user, :moderator, :admin]
  #
  #def admin?
  #  self.roles.include? 'admin'
  #end
  #
  #def moderator?
  #  self.roles.include? 'moderator'
  #end
  #
  #def verified?
  #  self.roles.include? 'verified_user'
  #end
  #
  #def self.find_first_by_auth_conditions(warden_conditions)
  #  conditions = warden_conditions.dup
  #  if login = conditions.delete(:login)
  #    result = self.any_of({ :username =>  /^#{Regexp.escape(login)}$/i }, { :email =>  /^#{Regexp.escape(login)}$/i }).first
  #    #return result if result
  #    #require "forum_user"
  #    #ForumUser.find(login)
  #  else
  #    super
  #  end
  #end
  #
  #def generate_forum_token
  #  self.forum_data
  #end

  def admin?
    false
  end

  def valid_password?(password)
    self.credential.valid_password? password
  end

  def generate_remember_token
    expire_time = 1.year.from_now
    token = SecureRandom.hex(16)
    self.update_attributes(member_login_key: token, member_login_key_expire: expire_time)
    { value: token, expires: expire_time }
  end

  def create_credential
    c = Credential.create!(converge_password: self.password, converge_email: self.email)
    self.credential = c
    self.id = c.changed_attributes[Credential.primary_key]
  end

  def create_extra
    self.extra = Extra.create!(id: self.credential.id)
  end

end

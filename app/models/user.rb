class User < Forum::Models
  include Tenacity
  include StElsewhere
  include Forum::Bankroll
  include Notificator

  User.configure do |config|
    config.notification_types = {
        internal: Notificator::Method::Internal,
        forum_message: Notificator::Method::ForumMessage,
        email: Notificator::Method::Email,
        sms: Notificator::Method::Sms,
    }
    config.default_type = :internal
  end

  self.table_name = 'ibf_members'

  before_create :create_credential, :set_default_values, :generate_verification_data
  after_create :create_extra

  attr_accessible :name, :email, :password, :member_login_key, :member_login_key_expire, :display_name, :verification_code, :verification_code_sent, :cash
  attr_accessor :password

  validates :password, length: {minimum: 6, maximum: 30}, on: :create
  validates :members_l_display_name, uniqueness: {case_sensitive: false}, length: {minimum: 3, maximum: 60}

  has_one :credential, foreign_key: 'converge_id', dependent: :destroy
  has_one :extra, foreign_key: 'id', dependent: :destroy
  t_has_many :notifications, dependent: :destroy
  t_has_many :packages, :class_name => 'Distribution::Package'
  t_has_many :banners
  t_has_many :records
  has_many_elsewhere :points, class_name: 'User', :through => :points_users
  has_and_belongs_to_many :roles

  scope :verified, where(is_verified: true)
  scope :not_verified, where(is_verified: false)

  def generate_verification_data
    self.verification_code = Digest::MD5.hexdigest(self.email + Time.now.to_i.to_s)
    self.verification_code_sent = Time.now.to_i
  end

  def verification_code_sent
    Time.at attributes['verification_code_sent']
  end

  def display_name=(value)
    self.members_display_name = value
    self.members_l_display_name = value
  end

  def display_name
    CGI::unescapeHTML(self.members_display_name)
  end

  def self.verify(verification_code, options={})
    return false unless verification_code.size == 32
    user = find_by_verification_code verification_code
    if Time.now <= user.verification_code_sent + eval(Settings.verification_code_valid_time)
      user.update_attribute(:is_verified, true) if options[:set_user_verified]
      user
    else
      false
    end
  end

  # @param [Symbol, Role] role
  def has_role?(role)
    return false if self.roles.empty?
    role = Role.find_by_name(role.to_s) if role.is_a?(Symbol) or role.is_a?(String)
    self.roles.include?(role)
  end

  def add_role(role)
    role = Role.find_by_name(role.to_s) if role.is_a?(Symbol) or role.is_a?(String)
    unless self.roles.include? role
      role.users << self
      role.save
    end
  end

  def valid_password?(password)
    self.credential.valid_password? password
  end

  def generate_remember_token
    expire_time = 1.year.from_now
    token = SecureRandom.hex(16)
    self.update_attributes(member_login_key: token, member_login_key_expire: expire_time)
    {value: token, expires: expire_time}
  end

  def create_credential
    c = Credential.create!(converge_password: self.password, converge_email: self.email)
    self.credential = c
    self.id = c.changed_attributes[Credential.primary_key]
  end

  def create_extra
    user_id = self.credential.changed_attributes[Credential.primary_key]
    self.extra = Extra.create!(id: user_id)
    #self.user_role = UserRole.create!(user_id: user_id, roles: Array.new)
  end

  def set_default_values
    self.name = self.email
    self.members_l_username = self.email
    self.mgroup = 3
    self.time_offset = 5
    self.joined = Time.now.to_i
  end

  def case?
    self.case_on and Time.now < Time.at(self.case_till)
  end

end

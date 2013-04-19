class User < ForumModels
  include Tenacity
  self.table_name = 'ibf_members'

  scope :verified, where(is_verified: true)
  scope :not_verified, where(is_verified: false)

  before_create :create_credential, :set_default_values, :generate_verification_data
  after_create :create_extra

  has_one :credential, foreign_key: 'converge_id'
  has_one :extra, foreign_key: 'id'
  t_has_many :banners
  t_has_many :records
  t_has_one :user_role

  attr_accessor :password
  #TODO выделить атрибуты для редактирования админом attr_protected
  attr_accessible :name, :email, :password, :member_login_key, :member_login_key_expire, :display_name, :verification_code, :verification_code_sent

  #validates :name, presence: true, uniqueness: {case_sensitive: false}, length: {minimum: 4, maximum: 30}
  validates :password, length: {minimum: 6, maximum: 30}, on: :create
  validates :members_l_display_name, uniqueness: {case_sensitive: false}, length: {minimum: 3, maximum: 60}

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
    self.members_display_name
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

  def has_role?(role_name)
    if self.user_role.nil?
      self.user_role = UserRole.create(user_id: self.id, roles: Array.new)
      self.save
      false
    else
      self.user_role.roles.include?(role_name.to_s)
    end
  end

  def add_role(role_name)
    self.user_role.roles << role_name
    self.user_role.save
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
    self.user_role = UserRole.create!(user_id: user_id, roles: Array.new)
  end

  def set_default_values
    self.name = self.email
    self.members_l_username = self.email
    self.mgroup = 3
    self.time_offset = 5
    self.joined = Time.now.to_i
  end

end

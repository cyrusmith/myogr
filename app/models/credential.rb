class Credential < ForumModels
  self.table_name = 'ibf_members_converge'
  self.primary_key = 'converge_id'

  before_save :set_timestamp

  belongs_to :member, foreign_key: 'id'

  attr_accessible :converge_email, :converge_joined, :converge_pass_hash,	:converge_pass_salt, :converge_password

  def converge_password=(password)
    self.converge_pass_salt = generate_salt
    self.converge_pass_hash = generate_password_hash password
  end

  def generate_password_hash(password)
    password = password.encode('cp1251')
    encoded_password = Digest::MD5.hexdigest(password).encode('cp1251')
    Digest::MD5.hexdigest(Digest::MD5.hexdigest(self.converge_pass_salt) + encoded_password).encode('cp1251')
  end

  def valid_password?(password)
    encoded_password = Digest::MD5.hexdigest(password.encode('cp1251')).encode('cp1251')
    encoded_password = Digest::MD5.hexdigest(Digest::MD5.hexdigest(self.converge_pass_salt.encode('cp1251')) + encoded_password).encode('cp1251')
    encoded_password.eql? self.converge_pass_hash
  end

  private

  # TODO подумать, как сделать лучше
  def generate_salt
    SecureRandom.hex(3)[0..4].encode('cp1251')
  end

  def set_timestamp
    self.converge_joined = Time.now.to_i
  end

end
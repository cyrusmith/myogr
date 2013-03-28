require 'iconv'

class Credential < ForumModels
  self.table_name = 'ibf_members_converge'
  self.primary_key = 'converge_id'

  belongs_to :member, foreign_key: 'id'

  attr_accessor :converge_id, :converge_email, :converge_joined, :converge_pass_hash,	:converge_pass_salt

  def initialize(email, password)
    @converge_email=email
    @converge_joined=Time.now.to_i
    @converge_pass_salt=generate_salt
    @converge_pass_hash=generate_password_hash password
  end

  def generate_password_hash(password)
    encoded_password = Digest::MD5.hexdigest(password)
    Digest::MD5.hexdigest(Digest::MD5.hexdigest(@converge_pass_salt) + encoded_password)
  end

  def valid_password?(password)
    #encoded_password = Iconv.conv('cp1251', 'utf8', password)
    #salt = Iconv.conv('cp1251', 'utf8', self.converge_pass_salt)
    encoded_password = Digest::MD5.hexdigest(password)
    encoded_password = Digest::MD5.hexdigest(Digest::MD5.hexdigest(@converge_pass_salt) + encoded_password)
    encoded_password.eql? self.converge_pass_hash
  end

  private

  def generate_salt
    SecureRandom.base64(5)
  end

end
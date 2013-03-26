require 'iconv'

class Credential < ForumModels
  self.table_name = 'ibf_members_converge'

  belongs_to :member, foreign_key: 'id'

  def valid_password?(password)
    #encoded_password = Iconv.conv('cp1251', 'utf8', password)
    #salt = Iconv.conv('cp1251', 'utf8', self.converge_pass_salt)
    encoded_password = Digest::MD5.hexdigest(password)
    encoded_password = Digest::MD5.hexdigest(Digest::MD5.hexdigest(self.converge_pass_salt) + encoded_password)
    encoded_password.eql? self.converge_pass_hash
  end
end
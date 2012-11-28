require 'mysql2'
require 'digest/md5'
require 'iconv'
require 'devise/strategies/base'

class ForumUser < Devise::Strategies::Base
  @@forum = Mysql2::Client.new(:host => "ogromno.com", :username => "lopinopulos", :password => "lopinopulos", :database => "mika007_forum", :encoding => "cp1251")
  attr_accessor :name, :email, :converge_pass_hash, :converge_pass_salt

  def initialize(id, name, mail, converge_pass_hash, converge_pass_salt, options)
    @id = id
    @name = name
    @email = mail
    @converge_pass_hash = converge_pass_hash
    @converge_pass_salt = converge_pass_salt
    @options = options
  end

  def self.find(login)
    result = @@forum.query("SELECT *
                 FROM ibf_members member
                 LEFT JOIN ibf_members_converge converge ON member.email=converge_email
                 LEFT JOIN ibf_member_extra extra ON member.id=extra.id
                 WHERE member.name='#{login}'").first
    ForumUser.new result["id"], result["name"], result["email"], result["converge_pass_hash"], result["converge_pass_salt"], result
  end

  def valid_password?(password)
    encoded_password = Iconv::iconv('cp1251', 'utf8', password)
    salt = Iconv::iconv('cp1251', 'utf8', @converge_pass_salt)
    encoded_password = Digest::MD5.hexdigest(encoded_password[0])
    encoded_password = Digest::MD5.hexdigest(Digest::MD5.hexdigest(salt[0]) + encoded_password)
    if Devise.secure_compare(encoded_password, @converge_pass_hash)
    u = User.create(:username => @name,
                    :email => @email,
                    :password => password,
                    :password_confirmation => password,
                    :forum_id => @id,
                    :forum_data => @options)
    u.save()
    end
  end

  def valid_for_authentication?
    block_given? ? yield : true
  end

  def after_database_authentication
  end

  def self.serialize_into_session(record)
    user = User.where(:username =>  record.name).first
    [user.to_key, user.authenticatable_salt]
  end

end
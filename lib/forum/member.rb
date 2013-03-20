require 'forum/connect/connectable'

module Forum
  class Member
    extend Forum::Connectable
    attr_accessor :options, :username, :pw_hash, :id, :email, :pw_salt

    def initialize(id, username, email, pw_hash, pw_salt, options={})
      @id = id
      @username = username
      @email = email
      @pw_hash = pw_hash
      @pw_salt = pw_salt
      @options = options
    end

    # @param [String] login
    # @param [String] password
    # @return [Hash or NilClass]
    def self.find login
      query = "SELECT *
               FROM ibf_members member
               LEFT JOIN ibf_members_converge converge ON member.email=converge_email
               LEFT JOIN ibf_member_extra extra ON member.id=extra.id
               WHERE member.name='#{login}'
               LIMIT 0,1"
      result = process_query(query).first
      if result
        Member.new result["id"], result["name"], result["email"], result["converge_pass_hash"], result["converge_pass_salt"], result
      else
        nil
      end
    end

    def valid_password? password
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

  end
end

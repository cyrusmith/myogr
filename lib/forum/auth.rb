module Forum
  class Auth < Warden::Strategies::Base
    def authenticate!
      login = params[:login]
      user = ::User.where('lower(members_display_name) = :value OR lower(email) = :value', value: Forum::Utils.escape(login.downcase)).first
      if user.present? and user.valid_password? params[:password]
        success!(user)
      else
        fail!
      end
    end

    def valid?
      params['login'] && params['password']
    end

    def success!(user, message=nil)
      super user, message
    end


  end
end

# for warden, `:my_authentication`` is just a name to identify the strategy
#Warden::Strategies.add :forum_auth, Forum::Auth

# for devise, there must be a module named 'MyAuthentication' (name.to_s.classify), and then it looks to warden
# for that strategy. This strategy will only be enabled for models using devise and `:my_authentication` as an
# option in the `devise` class method within the model.
#Devise.add_module :forum_auth, :strategy => true
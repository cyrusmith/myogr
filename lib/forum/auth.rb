module Forum
  class Auth < ::Devise::Strategies::Authenticatable
    def authenticate!
      # lookup session data with external api
      session_data = ForumUser.find params[:user][:login]

      # check if token was valid and authorise if so
      if session_data['error']
        # session lookup failed so fail authentication with message from api
        fail!(session_data['error'])
      else
        # we got some valid user data
        success!(User.find(session_data['user_id']))
      end
    end
  end
end

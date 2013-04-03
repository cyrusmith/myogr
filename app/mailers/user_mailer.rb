class UserMailer < ActionMailer::Base
  default from: "no-reply@ogromno.com"

  def verification_email(user)
    @user = user
    @url = user_verification_url(user.verification_code)
    mail(:to => user.email, :subject => "Verify your e-mail at Ogromno")
  end

end

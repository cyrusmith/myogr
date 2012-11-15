module ApplicationHelper
  # encoding: utf-8
  LOGO_PATH = 'ogromno-logo.png'

  def show_logo
    if current_page? :root
      return image_tag LOGO_PATH
    else
      return link_to image_tag(LOGO_PATH), root_path
    end
  end

  def welcome_user
    if user_signed_in?
      return
    else
      return t(:hi).capitalize + link_to(t(:sign_in).capitalize, new_user_session_path) + t(:or) + link_to(t(:register).capitalize, new_user_session_path)
    end
  end

end

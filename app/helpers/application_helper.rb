module ApplicationHelper
  # encoding: utf-8
  LOGO_ICON = 'ogromno-logo.png'

  def show_logo(logo_path=LOGO_ICON)
    if current_page? :root
      return image_tag logo_path
    else
      return link_to image_tag(logo_path), root_path
    end
  end

  def welcome_user
    if user_signed_in?
      return
    else
      return t(:hi).capitalize + link_to(t(:sign_in).capitalize, new_user_session_path) + t(:or) + link_to(t(:register).capitalize, new_user_session_path)
    end
  end

  def get_package_path
    active_package = current_user.packages.active.first
    return new_distribution_package_path if active_package.nil?
    if active_package.changeable?
      edit_distribution_package_path(active_package)
    else
      distribution_package_path(active_package)
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + '_fields', f: builder)
    end
    link_to(name, '#', class: 'add_fields', data: {id: id, :fields => fields.gsub('\n', '')})
  end

end

# encoding: utf-8
module ApplicationHelper

  def javascript(*files)
    content_for (:head) { javascript_include_tag(*files) }
  end

  LOGO_ICON = 'ogromno-logo.png'

  def show_logo(logo_path=LOGO_ICON)
    if current_page? :root
      return image_tag logo_path
    else
      return link_to image_tag(logo_path), main_app.root_path
    end
  end

  def welcome_user
    if user_signed_in?
      return
    else
      return t(:hi).capitalize + link_to(t(:sign_in).capitalize, new_user_session_path) + t(:or) + link_to(t(:register).capitalize, new_user_session_path)
    end
  end

  def rubles(number, is_need_unit = true)
    number_to_currency number, unit: (is_need_unit ? 'руб.' : ''), precision: 0
  end

  def link_to_place_current_mark(name, options = {}, html_options = {})
    link_to_unless_current name, options, html_options do |name|
      html_options[:class] = html_options[:class].to_s + ' current'
      content_tag :div, name, html_options
    end
  end

  def get_package_path
    user_packages = current_user.packages
    active_package = user_packages.empty? ? nil : user_packages.select{|package| package.active?}.first
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

  def progressbar(base, value, options={})
    percentage = base>0 ? ((value.to_f / base.to_f).round(2) * 100) : 0
    render 'shared/progressbar', percentage: percentage, size:options[:size], hint:options[:hint], color: options[:color]
  end

end

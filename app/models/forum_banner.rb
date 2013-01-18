require "ipb_forum/connect/connectable"
require 'nokogiri'

class ForumBanner < Banner
  include Forum::Connectable

  validates :link, :presence => true, :format => {:with => /forum.ogromno.ru/,
                                                  :message => "Only letters allowed"}

  def activate
    add_to_forum
    super
  end

  def deactivate
    remove_from_forum
    super
  end

  private

  # Generate HTML banner for forum
  def generate_banner
    banner_html = '<a href="' + self.link + '" id="' + self.link + '"><img src="' + Settings.host_url + self.image.url + '"></a>'
    logger.debug "Generated banner: #{banner_html}"
    banner_html
  end

  #Connect to forum and add banner
  def add_to_forum
    change_global_message do |html|
      html.css('div#buttons').each do |buttons_part|
        buttons_part << generate_banner
      end
    end
  end

  #Connect to forum and remove banner
  def remove_from_forum
    change_global_message do |html|
      banner = generate_banner
      html.css('div#buttons a').each do |link|
        link.remove if link.to_s.eql? banner
      end
    end
  end

  def change_global_message
    html = Nokogiri::HTML(get_global_message)
    yield html
    set_global_message html.to_s
    rebuild_cache
  end

  def get_global_message
    global_message_query = "SELECT conf_value FROM `ibf_conf_settings` WHERE `conf_id` =630"
    global_message = process_query(global_message_query).first
    global_message['conf_value']
  end

  def set_global_message message
    set_global_message = "UPDATE `ibf_conf_settings` SET conf_value = '" + message + "' WHERE `conf_id`=630"
    a = process_query(set_global_message)
  end

  def rebuild_cache
    open('http://forum.ogromno.ru/sources/api/remote.php?method=rebuild_cache')
  end

end
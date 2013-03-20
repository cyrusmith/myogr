require "forum/connect/connectable"

module Forum
  class PromoButton
    extend Forum::Connectable

    def self.add button_id, link, image_path
      global_message_query = "SELECT conf_value FROM `ibf_conf_settings` WHERE `conf_id` =630"
      global_message = process_query(global_message_query).first
      global_message["conf_value"] = global_message["conf_value"] << '<a id="' + button_id + 'href="' + link +'"><img src="'+ image_path + '"/></a>'

      set_global_message = 'UPDATE `ibf_conf_settings` SET conf_value = "' + global_message["conf_value"] +'" WHERE `conf_id`=630'
      process_query set_global_message
    end

    def self.remove

    end

  end
end
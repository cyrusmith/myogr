#encoding: utf-8
module Notificator
  module Method
    class ForumMessage < Forum::Models

      # 1.Создать запись в таблице ibf_message_text с текстом сообщения + post_key md5(microtime())
      # 2.Создать запись в таблице ibf_message_topics со ссылкой на 1
      # 3.Обновить данные у members_extra и members
      def self.notify(recipient, text, options={})
        title = (options[:title] || 'Уведомление').encode('cp1251')
        self.transaction do
          creation_time = Time.now.to_i
          epoch_mirco = Time.now.to_f
          epoch_full = Time.now.to_i
          epoch_fraction = epoch_mirco - epoch_full
          microtime = epoch_fraction.to_s + ' ' + epoch_full.to_s
          message_text_sql = "INSERT INTO `ibf_message_text`(`msg_date`,	`msg_post`,	`msg_sent_to_count`, `msg_post_key`, `msg_author_id`,	`msg_ip_address`)
                                                            VALUES (#{creation_time}, '#{text.encode('cp1251')}', 1, '#{::Digest::MD5.hexdigest(microtime)}', 1, '#{recipient.ip_address}')"
          message_id = self.connection.insert message_text_sql
          puts "message_text inserted. new id is #{message_id}"
          insert_message_topics = "INSERT INTO `ibf_message_topics`(`mt_msg_id`, `mt_date`,	`mt_title`,	`mt_from_id`,	`mt_to_id`,	`mt_vid_folder`,`mt_owner_id`)
                                                            VALUES (#{message_id}, #{creation_time}, '#{title}', 1, #{recipient.id}, 'in', #{recipient.id})"
          topic_id = self.connection.insert insert_message_topics
          puts "message_topic inserted. topic id is #{topic_id}"
          recipient.new_msg = recipient.new_msg + 1
          recipient.msg_total = recipient.msg_total+1
          recipient.show_popup=1
          serialized_virtual_dirs = recipient.extra.vdirs
          recipient.extra.vdirs = serialized_virtual_dirs.gsub(/in:Входящие;(\d+)/,"in:Входящие;#{$1.to_i+1}")
          recipient.extra.save!
          recipient.save!
          puts 'user data refreshed'
        end
      end

    end
  end
end
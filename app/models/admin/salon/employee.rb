module Admin
  module Salon
    class Employee

      include Mongoid::Document
      field :first_name, type: String
      field :last_name, type: String
      field :position, type: String
      field :specialization, type: String

      def avaliable_time(date)
        start_time = Time.parse Admin::Salon::Settings.schedule.mon.from
        end_time = Time.parse Admin::Salon::Settings.schedule.mon.till
        time_range = start_time.split_by 30.minutes, end_time
        time_range - busy_time(date)
      end

      def busy_time(date)
        busy_time = []
        day_records = Record.where(record_date: date, employee: self.id)
        day_records.each do |record|
          time = record.record_time + (record.total_duration).hours
          #busy_time += .split_by(30.minutes, time)
          #TODO разобраться почему не работает из класса Time - проблема с UTC
          busy_time = busy_time + [record.record_time].tap do |array|
            array << array.last + 30.minutes while array.last < time
          end
        end
        return busy_time
      end

    end
  end
end

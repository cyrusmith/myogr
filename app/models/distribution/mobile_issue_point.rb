module Distribution
  class MobileIssuePoint < Point
    has_many :location_schedules, class_name: 'Distribution::LocationSchedule', foreign_key: :point_id

    def default_package_list_amount
      2
    end

    # Количество дней, доступных для записи пользователю
    def self.record_time_duration
      7.days
    end

  end
end
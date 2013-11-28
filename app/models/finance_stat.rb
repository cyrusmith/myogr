class FinanceStat < Forum::Models
  class << self
    def year_income(date = Date.today, years_count = 1)
      date = date.to_datetime
      start_period = date.years_ago(years_count - 1).beginning_of_year.to_i
      end_period = date.end_of_year.to_i
      get_year_stat date, years_count do
        "SELECT YEAR(FROM_UNIXTIME(`date`)) AS `year`,
                MONTH( FROM_UNIXTIME(`date`)) AS `month`,
                `group_name`,
                SUM(`sum`) as `total`
                FROM `ibf_money_log`
                WHERE `from_member`=0 AND `date` BETWEEN #{start_period} AND #{end_period}
                GROUP BY `year`, `month`, `group_name`"
      end
    end

    def year_earnings(date = Date.today, years_count = 1)
      date = date.to_datetime
      start_period = date.years_ago(years_count - 1).beginning_of_year.to_i
      end_period = date.end_of_year.to_i
      get_year_stat date, years_count do
        "SELECT YEAR(FROM_UNIXTIME(`date`)) AS `year`,
                MONTH( FROM_UNIXTIME(`date`)) AS `month`,
                `group_name`,
                SUM(`sum`) as `total`
                FROM `ibf_money_log`
                WHERE `to_member`=1 AND `date` BETWEEN #{start_period} AND #{end_period}
                GROUP BY `year`, `month`, `group_name`"
      end
    end

    private

    def get_year_stat(date, years_count, &block)
      result = {}
      query_result = connection.select_all yield()
      (1..years_count).each do |i|
        current_year = date.years_ago(i-1).year
        result[current_year] = get_months_stat(current_year, query_result)
      end
      result
    end

    def get_months_stat(year, results_array)
      result = {}
      (1..12).each do |month_number|
        result[month_number] = {}
        month_results = results_array.find_all do |month_stat|
          month_stat['year'] == year && month_stat['month'] == month_number
        end
        grand_total = 0
        result[month_number] = {}
        month_results.each do |group|
          group_name = group['group_name']
          total = group.try(:[], 'total') || 0
          result[month_number][group_name.to_sym] = total
          grand_total = grand_total + total
        end
        result[month_number][:total] = grand_total
      end
      result
    end
  end
end
require 'spec_helper'

describe FinanceStat do
  it 'should return array of month financial stats' do
    result = FinanceStat.year_income(Date.parse('2013-09-01'))
    puts result.inspect
    (result.is_a?(Hash) && result.has_key?(2013) && result[2013].is_a?(Hash) && result[2013].keys.length == 12 &&
        result[2013][1].is_a?(Hash)).should be_true
  end
  it 'should return results for more then one year' do
    years_count = 2
    result = FinanceStat.year_earnings(Date.parse('2013-09-01'), years_count)
    result.keys.length.eql? years_count
  end
end
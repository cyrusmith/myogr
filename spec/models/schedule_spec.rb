require 'spec_helper'

describe Schedule do
  before(:each) do
    @schedule = Schedule.new
  end
  it 'should add date in string and date formats' do
    @schedule.date = '18.04.2013'
    @schedule.save
    @schedule.date.eql?(Date.new(2013, 4, 18)).should be_true
  end
  it "should set till and from open time" do
    @schedule.till= '11.00'
    @schedule.save
  end
end

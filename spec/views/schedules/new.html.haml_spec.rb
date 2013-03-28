require 'spec_helper'

describe "schedules/new" do
  before(:each) do
    assign(:schedule, stub_model(Schedule,
      :date => "",
      :working_from => ""
    ).as_new_record)
  end

  it "renders new schedule form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => schedules_path, :method => "post" do
      assert_select "input#schedule_date", :name => "schedule[date]"
      assert_select "input#schedule_working_from", :name => "schedule[working_from]"
    end
  end
end

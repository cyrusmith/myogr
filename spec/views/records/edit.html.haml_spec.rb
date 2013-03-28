require 'spec_helper'

describe "records/edit" do
  before(:each) do
    @record = assign(:record, stub_model(Record,
      :user => "",
      :procedures => "",
      :employee => ""
    ))
  end

  it "renders the edit record form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => records_path(@record), :method => "post" do
      assert_select "input#record_user", :name => "record[user]"
      assert_select "input#record_procedures", :name => "record[procedures]"
      assert_select "input#record_employee", :name => "record[employee]"
    end
  end
end

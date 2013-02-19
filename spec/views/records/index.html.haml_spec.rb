require 'spec_helper'

describe "records/index" do
  before(:each) do
    assign(:records, [
      stub_model(Record,
        :user => "",
        :procedures => "",
        :employee => ""
      ),
      stub_model(Record,
        :user => "",
        :procedures => "",
        :employee => ""
      )
    ])
  end

  it "renders a list of records" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end

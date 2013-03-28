require 'spec_helper'

describe "admin/salons/index" do
  before(:each) do
    assign(:admin_salon_procedures, [
      stub_model(Admin::Salon::Procedure,
        :name => "Name",
        :duration => 1.5,
        :price => "",
        :comment => "Comment",
        :group => "Group"
      ),
      stub_model(Admin::Salon::Procedure,
        :name => "Name",
        :duration => 1.5,
        :price => "",
        :comment => "Comment",
        :group => "Group"
      )
    ])
  end

  it "renders a list of admin/salons" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Comment".to_s, :count => 2
    assert_select "tr>td", :text => "Group".to_s, :count => 2
  end
end

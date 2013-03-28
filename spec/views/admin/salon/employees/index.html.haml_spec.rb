require 'spec_helper'

describe "admin/salons/index" do
  before(:each) do
    assign(:admin_salon_employees, [
      stub_model(Admin::Salon::Employee,
        :first_name => "",
        :last_name => "",
        :position => "Position"
      ),
      stub_model(Admin::Salon::Employee,
        :first_name => "",
        :last_name => "",
        :position => "Position"
      )
    ])
  end

  it "renders a list of admin/salons" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Position".to_s, :count => 2
  end
end

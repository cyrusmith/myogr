require 'spec_helper'

describe "admin/salons/show" do
  before(:each) do
    @admin_salon = assign(:admin_salon, stub_model(Admin::Salon::Employee,
      :first_name => "",
      :last_name => "",
      :position => "Position"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/Position/)
  end
end

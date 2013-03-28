require 'spec_helper'

describe "admin/salons/show" do
  before(:each) do
    @admin_salon = assign(:admin_salon, stub_model(Admin::Salon::Procedure,
      :name => "Name",
      :duration => 1.5,
      :price => "",
      :comment => "Comment",
      :group => "Group"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/1.5/)
    rendered.should match(//)
    rendered.should match(/Comment/)
    rendered.should match(/Group/)
  end
end

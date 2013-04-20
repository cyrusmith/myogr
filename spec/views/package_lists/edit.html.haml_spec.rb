require 'spec_helper'

describe "package_lists/edit" do
  before(:each) do
    @package_list = assign(:package_list, stub_model(PackageList))
  end

  it "renders the edit package_list form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", package_list_path(@package_list), "post" do
    end
  end
end

require 'spec_helper'

describe "package_lists/show" do
  before(:each) do
    @package_list = assign(:package_list, stub_model(PackageList))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end

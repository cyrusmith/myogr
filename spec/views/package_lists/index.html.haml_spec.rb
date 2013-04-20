require 'spec_helper'

describe "package_lists/index" do
  before(:each) do
    assign(:package_lists, [
      stub_model(PackageList),
      stub_model(PackageList)
    ])
  end

  it "renders a list of package_lists" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end

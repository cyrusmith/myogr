require 'spec_helper'

describe "package_lists/new" do
  before(:each) do
    assign(:package_list, stub_model(PackageList).as_new_record)
  end

  it "renders new package_list form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", package_lists_path, "post" do
    end
  end
end

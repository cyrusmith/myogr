require 'spec_helper'

describe "distribution/packages/new" do
  before(:each) do
    assign(:distribution_package, stub_model(Distribution::Package,
      :order => "",
      :state => "MyString"
    ).as_new_record)
  end

  it "renders new distribution_package form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", distribution_packages_path, "post" do
      assert_select "input#distribution_package_order[name=?]", "distribution_package[order]"
      assert_select "input#distribution_package_state[name=?]", "distribution_package[state]"
    end
  end
end

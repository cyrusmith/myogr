require 'spec_helper'

describe "distribution/packages/edit" do
  before(:each) do
    @distribution_package = assign(:distribution_package, stub_model(Distribution::Package,
      :order => "",
      :state => "MyString"
    ))
  end

  it "renders the edit distribution_package form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", distribution_package_path(@distribution_package), "post" do
      assert_select "input#distribution_package_order[name=?]", "distribution_package[order]"
      assert_select "input#distribution_package_state[name=?]", "distribution_package[state]"
    end
  end
end

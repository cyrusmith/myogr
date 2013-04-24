require 'spec_helper'

describe "distribution/packages/index" do
  before(:each) do
    assign(:distribution_packages, [
      stub_model(Distribution::Package,
        :order => "",
        :state => "State"
      ),
      stub_model(Distribution::Package,
        :order => "",
        :state => "State"
      )
    ])
  end

  it "renders a list of distribution/packages" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
  end
end

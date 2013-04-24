require 'spec_helper'

describe "distribution/packages/show" do
  before(:each) do
    @distribution_package = assign(:distribution_package, stub_model(Distribution::Package,
      :order => "",
      :state => "State"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/State/)
  end
end

require 'spec_helper'

describe "distribution_centers/show" do
  before(:each) do
    @distribution_center = assign(:distribution_center, stub_model(DistributionCenter))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end

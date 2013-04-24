require 'spec_helper'

describe "distribution_centers/index" do
  before(:each) do
    assign(:points, [
      stub_model(Point),
      stub_model(Point)
    ])
  end

  it "renders a list of distribution_centers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end

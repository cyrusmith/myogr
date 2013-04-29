require 'spec_helper'

describe "distributions/index" do
  before(:each) do
    assign(:distributors, [
      stub_model(Distribution),
      stub_model(Distribution)
    ])
  end

  it "renders a list of distributions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end

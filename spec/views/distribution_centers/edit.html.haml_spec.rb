require 'spec_helper'

describe "distribution_centers/edit" do
  before(:each) do
    @distribution_center = assign(:distribution_center, stub_model(DistributionCenter))
  end

  it "renders the edit distribution_center form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", distribution_center_path(@distribution_center), "post" do
    end
  end
end

require 'spec_helper'

describe "distribution_centers/edit" do
  before(:each) do
    @point = assign(:point, stub_model(Point))
  end

  it "renders the edit distribution_center form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", distribution_center_path(@point), "post" do
    end
  end
end

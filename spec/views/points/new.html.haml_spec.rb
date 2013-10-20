require 'spec_helper'

describe "distribution_centers/new" do
  before(:each) do
    assign(:point, stub_model(Point).as_new_record)
  end

  it "renders new distribution_center form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", distribution_centers_path, "post" do
    end
  end
end

require 'spec_helper'

describe "addresses/new" do
  before(:each) do
    assign(:location, stub_model(Location).as_new_record)
  end

  it "renders new address form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", addresses_path, "post" do
    end
  end
end

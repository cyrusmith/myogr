require 'spec_helper'

describe "addresses/edit" do
  before(:each) do
    @location = assign(:location, stub_model(Location))
  end

  it "renders the edit address form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", address_path(@location), "post" do
    end
  end
end

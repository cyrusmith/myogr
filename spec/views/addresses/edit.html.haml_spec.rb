require 'spec_helper'

describe "addresses/edit" do
  before(:each) do
    @address = assign(:address, stub_model(Address))
  end

  it "renders the edit address form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", address_path(@address), "post" do
    end
  end
end

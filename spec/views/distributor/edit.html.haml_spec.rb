require 'spec_helper'

describe "distributions/edit" do
  before(:each) do
    @distribution = assign(:distribution, stub_model(Distribution))
  end

  it "renders the edit distribution form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", distribution_path(@distribution), "post" do
    end
  end
end

require 'spec_helper'

describe "distributions/new" do
  before(:each) do
    assign(:distribution, stub_model(Distribution).as_new_record)
  end

  it "renders new distribution form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", distributions_path, "post" do
    end
  end
end

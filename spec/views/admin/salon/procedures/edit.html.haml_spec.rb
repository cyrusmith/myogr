require 'spec_helper'

describe "admin/salons/edit" do
  before(:each) do
    @admin_salon = assign(:admin_salon, stub_model(Admin::Salon::Procedure,
      :name => "MyString",
      :duration => 1.5,
      :price => "",
      :comment => "MyString",
      :group => "MyString"
    ))
  end

  it "renders the edit admin_salon form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_salon_procedures_path(@admin_salon), :method => "post" do
      assert_select "input#admin_salon_name", :name => "admin_salon[name]"
      assert_select "input#admin_salon_duration", :name => "admin_salon[duration]"
      assert_select "input#admin_salon_price", :name => "admin_salon[price]"
      assert_select "input#admin_salon_comment", :name => "admin_salon[comment]"
      assert_select "input#admin_salon_group", :name => "admin_salon[group]"
    end
  end
end

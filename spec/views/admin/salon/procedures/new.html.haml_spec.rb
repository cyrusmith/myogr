require 'spec_helper'

describe "admin/salons/new" do
  before(:each) do
    assign(:admin_salon, stub_model(Admin::Salon::Procedure,
      :name => "MyString",
      :duration => 1.5,
      :price => "",
      :comment => "MyString",
      :group => "MyString"
    ).as_new_record)
  end

  it "renders new admin_salon form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_salon_procedures_path, :method => "post" do
      assert_select "input#admin_salon_name", :name => "admin_salon[name]"
      assert_select "input#admin_salon_duration", :name => "admin_salon[duration]"
      assert_select "input#admin_salon_price", :name => "admin_salon[price]"
      assert_select "input#admin_salon_comment", :name => "admin_salon[comment]"
      assert_select "input#admin_salon_group", :name => "admin_salon[group]"
    end
  end
end

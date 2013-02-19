require 'spec_helper'

describe "admin/salons/new" do
  before(:each) do
    assign(:admin_salon, stub_model(Admin::Salon::Employee,
      :first_name => "",
      :last_name => "",
      :position => "MyString"
    ).as_new_record)
  end

  it "renders new admin_salon form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_salon_employees_path, :method => "post" do
      assert_select "input#admin_salon_first_name", :name => "admin_salon[first_name]"
      assert_select "input#admin_salon_last_name", :name => "admin_salon[last_name]"
      assert_select "input#admin_salon_position", :name => "admin_salon[position]"
    end
  end
end

require 'spec_helper'

describe "admin/salons/edit" do
  before(:each) do
    @admin_salon = assign(:admin_salon, stub_model(Admin::Salon::Employee,
      :first_name => "",
      :last_name => "",
      :position => "MyString"
    ))
  end

  it "renders the edit admin_salon form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_salon_employees_path(@admin_salon), :method => "post" do
      assert_select "input#admin_salon_first_name", :name => "admin_salon[first_name]"
      assert_select "input#admin_salon_last_name", :name => "admin_salon[last_name]"
      assert_select "input#admin_salon_position", :name => "admin_salon[position]"
    end
  end
end

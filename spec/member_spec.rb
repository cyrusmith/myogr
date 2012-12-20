require "rspec"
require "ipb_forum/member"

describe "Find User" do

  it "should find user in forum db" do

    result = Forum::Member.find("lopinopulos")
    result.is_a?(Forum::Member).should == true
  end

  it "should not find nonexistent user in the database" do
    result = Forum::Member.find("nonexistent_user")
    result.should == nil
  end
end
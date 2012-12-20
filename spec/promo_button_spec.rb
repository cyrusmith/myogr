require "rspec"
require "ipb_forum/promo_button"

describe "Promo buttons on forum" do

  it "should add button to forum" do

    Forum::PromoButton.add
    true.should == true
  end

  it "should remove button from forum" do
    Forum::PromoButton.remove
  end
end
require "spec_helper"

describe Distribution::PackagesController do
  describe "routing" do

    it "routes to #index" do
      get("/distribution/packages").should route_to("distribution/packages#index")
    end

    it "routes to #new" do
      get("/distribution/packages/new").should route_to("distribution/packages#new")
    end

    it "routes to #show" do
      get("/distribution/packages/1").should route_to("distribution/packages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/distribution/packages/1/edit").should route_to("distribution/packages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/distribution/packages").should route_to("distribution/packages#create")
    end

    it "routes to #update" do
      put("/distribution/packages/1").should route_to("distribution/packages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/distribution/packages/1").should route_to("distribution/packages#destroy", :id => "1")
    end

  end
end

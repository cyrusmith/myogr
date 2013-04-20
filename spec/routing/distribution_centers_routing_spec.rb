require "spec_helper"

describe DistributionCentersController do
  describe "routing" do

    it "routes to #index" do
      get("/distribution_centers").should route_to("distribution_centers#index")
    end

    it "routes to #new" do
      get("/distribution_centers/new").should route_to("distribution_centers#new")
    end

    it "routes to #show" do
      get("/distribution_centers/1").should route_to("distribution_centers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/distribution_centers/1/edit").should route_to("distribution_centers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/distribution_centers").should route_to("distribution_centers#create")
    end

    it "routes to #update" do
      put("/distribution_centers/1").should route_to("distribution_centers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/distribution_centers/1").should route_to("distribution_centers#destroy", :id => "1")
    end

  end
end

require "spec_helper"

describe PackageListsController do
  describe "routing" do

    it "routes to #index" do
      get("/package_lists").should route_to("package_lists#index")
    end

    it "routes to #new" do
      get("/package_lists/new").should route_to("package_lists#new")
    end

    it "routes to #show" do
      get("/package_lists/1").should route_to("package_lists#show", :id => "1")
    end

    it "routes to #edit" do
      get("/package_lists/1/edit").should route_to("package_lists#edit", :id => "1")
    end

    it "routes to #create" do
      post("/package_lists").should route_to("package_lists#create")
    end

    it "routes to #update" do
      put("/package_lists/1").should route_to("package_lists#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/package_lists/1").should route_to("package_lists#destroy", :id => "1")
    end

  end
end

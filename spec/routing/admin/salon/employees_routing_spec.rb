require "spec_helper"

describe Admin::Salon::EmployeesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/salons").should route_to("admin/salons#index")
    end

    it "routes to #new" do
      get("/admin/salons/new").should route_to("admin/salons#new")
    end

    it "routes to #show" do
      get("/admin/salons/1").should route_to("admin/salons#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/salons/1/edit").should route_to("admin/salons#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/salons").should route_to("admin/salons#create")
    end

    it "routes to #update" do
      put("/admin/salons/1").should route_to("admin/salons#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/salons/1").should route_to("admin/salons#destroy", :id => "1")
    end

  end
end

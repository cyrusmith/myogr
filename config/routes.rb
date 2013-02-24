Ogromno::Application.routes.draw do

  resources :records

  resources :schedules

  get "sessions/new"

  root :to => "home#index"

  get 'contacts', :to => 'home#contacts'
  get 'advertisment', :to => 'home#advertisment'
  get 'rules', :to => 'home#rules'
  get 'agreement', :to => 'home#agreement'
  get 'offer', :to => 'home#offer'

  devise_for :user

  devise_scope :user do
    get "sign_in", :to => "devise/sessions#new"
    post "sign_in", :to => "sessions#create", :as => "post_user_session"
    get "sign_out", :to => "devise/sessions#destroy"
  end

  resources :banners
  match 'new_banner/step1' => 'banners#create_step1', :as => :create_banner_step1
  match 'new_banner/step2/:type' => 'banners#create_step2', :as => :create_banner_step2
  match 'banners/:id/activate' => 'banners#activate', :as => :activate_banner
  match 'banners/:id/deactivate' => 'banners#deactivate', :as => :deactivate_banner

  namespace :admin do
    resources :promo_place
    namespace :salon do
      resources :employees
      resources :procedures
    end
  end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end

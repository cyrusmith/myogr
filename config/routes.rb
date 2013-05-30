Ogromno::Application.routes.draw do

  root :to => 'home#index'

  resources :users, :except => :destroy
  match 'user/find' => 'users#find', :as => :find_users

  # if user is not logged in, he can log in, sign up and recover his password. Route is not accessible overwise
  scope constraints: lambda { |request| request.env['warden'].user.nil? } do
    get 'login', :to => 'sessions#new', :as => 'login'
    get 'signup', :to => 'users#new', :as => 'signup'
    match 'user/remind' => 'users#remind', :as => :user_remind, :via => [:get, :post]
    match 'users/recover_password/:verification_code' => 'users#recover_password', :as => :user_password_recovery, :via => :get
    match 'user/recover_password' => 'users#set_new_password', :as => :user_set_new_password, :via => :put
  end

  # if user is logged in, he can log out. Route is not accessible overwise
  scope constraints: lambda { |request| !request.env['warden'].user.nil? } do
    get 'logout', :to => 'sessions#destroy', :as => 'logout'
  end

  match 'users/verify/:verification_code' => 'users#verification', :as => :user_verification, :via => :get

  get 'search', :to => 'searches#index'

  resources :records
  match 'record/step1' => 'records#create_step1', :as => :create_record_step1
  match 'record/step2/:group' => 'records#create_step2', :as => :create_record_step2
  match 'remote/get_avaliable_time' => 'records#get_avaliable_time_remote'

  resources :schedules
  resources :addresses

  get 'contacts', :to => 'home#contacts'
  get 'advertisment', :to => 'home#advertisment'
  get 'rules', :to => 'home#rules'
  get 'agreement', :to => 'home#agreement'
  get 'offer', :to => 'home#offer'

  resources :sessions

  resources :banners
  resources :distributors, :except => [:destroy, :update]

  match 'new_banner/step1' => 'banners#create_step1', :as => :create_banner_step1
  match 'new_banner/step2/:type' => 'banners#create_step2', :as => :create_banner_step2
  match 'banners/:id/activate' => 'banners#activate', :as => :activate_banner
  match 'banners/:id/deactivate' => 'banners#deactivate', :as => :deactivate_banner

  get 'distributor/remove/:tid' => 'distributors#remove', :as => :remove_from_cabinet

  namespace :distribution do
    resources :packages
    resources :points do
      match 'collect_package' => 'points#collect_package'
      resources :package_lists do
        get 'packing_lists' => 'package_lists#packing_lists'
      end
      put 'package_list/:id/fire_event/:event'=> 'package_lists#fire_event', :as => :fire_package_list_event
      get 'package_list/days_off'=> 'package_lists#days_off'
      get 'package_list/switch_day_off' => 'package_lists#switch_day_off', :as => :switch_day_off
      get 'package_list/change_limit' => 'package_lists#change_limit'
      get 'package_list' => 'package_lists#show'
      get 'package_list/find_package' => 'package_lists#find_package', :as => :find_package
    end
  end

  namespace :admin do
    resources :promo_place
    namespace :salon do
      resources :records
      resources :employees
      resources :procedures
    end
  end

end

Soks::Application.routes.draw do
  
  resources :cost_categories do
    resources :costs
    member do 
      get 'changes'
      get 'follow'
      get 'un_follow'
    end
  end
  
  match "cost_categories/help/:input_id" => 'cost_categories#help'

  resources :cost_sources do
    resources :costs
    member do 
      get 'changes'
      get 'follow'
      get 'un_follow'
    end
  end

  resources :costs do
    member do 
      get 'changes'
      get 'follow'
      get 'un_follow'
    end
    collection do
      get 'bulk_update'
      post 'bulk'
      get 'parse_failures'
    end
  end
  
  match "costs/help/:input_id" => 'costs#help'
  
  resources :pages do
    member do 
      get 'changes'
      get 'follow'
      get 'un_follow'
      get 'compiled'
    end
  end
  
  resources :pictures do
    member do 
      get 'changes'
      get 'follow'
      get 'un_follow'
    end
  end
  
  resources :categories do
    member do 
      get 'changes'
      get 'follow'
      get 'un_follow'
      get 'compiled'
    end
  end

  resources :versions do
    member do
      post :revert
    end    
  end
  
  devise_for :users, :controllers => {:registrations => 'registrations'}
  
  resources :users do
    member do 
      get 'waiting_for_confirmation'
      get 'changes'
      get 'follow'
      get 'un_follow'
      post 'activate'
      post 'disable'
    end
  end

  match 'search' => 'search#index', :as => :search
  match 'index', :to => 'site#index', :as => :index
  match 'recent_changes(/:offset)', :to => 'site#recent', :as => :recent_changes
  root :to => "site#home"
  
  
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

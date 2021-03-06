ChainMeUp::Application.routes.draw do
 
  get "welcome/index"

  devise_for :users, :path => '', :controllers => {:sessions => 'sessions', :registrations => 'registrations'}, :path_names => { :sign_in => '/users/sign_in', :password => 'forgot', :confirmation => 'confirm', :unlock => 'unblock', :registration => '', :sign_up => '/users/sign_up', :sign_out => 'logout'}

  # get "/users/sign_in" => 'sessions#login'

  root 'welcome#index'

  get '/home' => 'welcome#home'

  get "/submit" => 'invitations#show'

  get '/trees/new' => 'trees#new', :as => "new_tree"

  post '/trees' => 'trees#create'

  get '/trees' => 'trees#index'

  get '/trees/:id' => 'trees#show', :as => "tree"

  patch '/trees/:id' => 'trees#update'

  get '/trees/:id/branch/:branch_id/new' => 'branches#new', :as => "new_branch"

  post '/trees/:id/branch/:branch_id' => 'branches#create', :as => "create_branch" 

  post '/trees/:id/branch/:branch_id/invitations' => 'invitations#create', :as => "create_invitations"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

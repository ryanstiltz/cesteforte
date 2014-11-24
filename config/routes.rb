Rails.application.routes.draw do
  # preforms all the routes that were generated for shoppe admin
  mount Shoppe::Engine => "/shoppe"
  
  # Routes for the store aspect of the site, routes to product
  get 'product/:permalink' => 'products#show', :as => 'product'
  post 'product/:permalink' => 'products#buy'

  get 'products' => 'products#index'

  # Routes for general parts of the site like the index and some other contact information
  root :to => 'site#index'

  #temp route to basket
  get 'basket' => 'orders#show'

  #route for emptying cart
  delete 'basket' => 'orders#destroy'

  #route for checkout process which is handled in the orders controller
  match 'checkout' => 'orders#checkout', :as => 'checkout', :via => [:get, :patch]
  post 'checkout/pay' => 'orders#payment', :as => 'checkout_payment'
  match 'checkout/confirm' => 'orders#confirmation', :as => 'checkout_confirmation', :via => [:get, :post]
  
  post "/hook" => "orders#hook"
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

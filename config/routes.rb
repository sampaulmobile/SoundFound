SoundFound::Application.routes.draw do

  ActiveAdmin.routes(self)
  mount Sidekiq::Web, at: "/sidekiq"

  devise_for :admins, module: "admins"
  devise_for :users, module: "users"

  root to: "static_pages#home"

  resources :soundcloud_users, path: "/soundcloud/users"
  resources :alerts, except: [:delete]

  get '/help',    to: 'static_pages#help'
  get '/contact', to: 'static_pages#contact'
  
  get '/update',  to: 'users#update_tracks'
  get '/filter',  to: 'soundcloud_users#show',    as: :filter
  get '/stream',  to: 'soundcloud_users#stream',  as: :stream

  get '/update/:id', to: 'soundcloud_users#update_user', as: :update_user
  
  get '/sign_out', to: 'users/sessions_controller#destroy'
  
  get '/like/:track_id', to: 'soundcloud_users#like_track', as: :like_track
  get '/unlike/:track_id', to: 'soundcloud_users#unlike_track', as: :unlike_track
  get '/download/:track_id', to: 'soundcloud_users#download_track', as: :download_track
  
  get '/stream/alert/:alert_id',   to: 'soundcloud_users#stream', as: :stream_alert
  get '/stream/add/:alert_id',     to: 'alerts#add',              as: :add_alert
  get '/stream/remove/:alert_id',  to: 'alerts#remove',           as: :remove_alert
  get '/stream/clear',             to: 'alerts#clear',            as: :clear_alerts
  get '/stream/delete',            to: 'alerts#delete',           as: :delete_alert

  get '/stream/match/:track_id/:alert_id', to:'soundcloud#match'
  get '/stream/summary/:user_id', to:'soundcloud#summary'
  
  get '/soundcloud',            to: 'soundcloud#index'
  get '/soundcloud/connect',    to: 'soundcloud#connect',    as: :soundcloud_connect
  get '/soundcloud/connected',  to: 'soundcloud#connected',  as: :soundcloud_connected
  get '/soundcloud/disconnect', to: 'soundcloud#disconnect', as: :soundcloud_disconnect
  get '/soundcloud/download',   to: 'soundcloud#download',   as: :soundcloud_download

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

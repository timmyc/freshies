Cone::Application.routes.draw do
  #devise_for :shredders, :path => "shredders", :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :registration => 'register', :sign_up => 'sign_up' }
  devise_for :shredders
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  match 'confirm' => 'shredders#confirm', :as => :confirm
  match 'doconfirm' => 'shredders#do_confirm', :as => :do_confirm
  match 'greetings/:id' => 'alerts#answer', :as => :answer
  match 'in/:id' => 'alerts#in', :as => :link_alert
  #match 'confirm-email' => 'shredders#send_email_instructions', :as => :send_email_instructions

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  resources :snow_reports
  resources :shredders
  resources :subscriptions
  resources :text_subscriptions, :controller => 'subscriptions'
  resources :voice_subscriptions, :controller => 'subscriptions'

  namespace :api do
    resources :android
    resources :area do
      member do
        get 'last_report'
      end
    end
    resources :passes do
      collection do
        get 'real_time'
        get 'end_of_day'
      end
    end
    resources :ios
    resources :forecast
    resources :sms
  end

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
  root :to => 'shredders#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

Pixassistant::Application.routes.draw do

  match 'login' => 'openids#pixnet', :as => :login
  match 'logout' => 'openids#logout', :as => :logout

  resources :oauth_consumers do
    get "callback", :on => :member
  end

  root :to => "home#index"

  namespace "blog" do
    resources :comments do
      post "reply", :on => :member
      post "destroy_batch", :on => :collection
    end
  end

  resources :assistances

end

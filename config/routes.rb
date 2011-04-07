Pixassistant::Application.routes.draw do

  match 'login' => 'openids#pixnet', :as => :login
  match 'logout' => 'openids#logout', :as => :logout

  match 'home/master' => 'home#master'

  resources :oauth_consumers do
    get "callback", :on => :member
  end

  root :to => "home#index"

  namespace "blog" do
    resources :comments do
      post "reply", :on => :member
      post "mark_ham", :on => :member
      post "destroy_batch", :on => :collection
      post "mark_spam_batch", :on => :collection
      post "open_batch", :on => :collection
      post "close_batch", :on => :collection
    end
  end

  resources :assistances

end

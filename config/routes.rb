Pixassistant::Application.routes.draw do

  match 'login' => 'openids#pixnet', :as => :login
  match 'logout' => 'openids#logout', :as => :logout

  resources :oauth_consumers do
    get "callback", :on => :member
  end

  root :to => "home#index"

end

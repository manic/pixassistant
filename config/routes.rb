Pixassistant::Application.routes.draw do

  match 'login' => 'openids#pixnet', :as => :login
  match 'logout' => 'openids#logout', :as => :logout

  root :to => "home#index"

end

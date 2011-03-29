OAUTH_CREDENTIALS = {
  :pixnet => {
    :key => ENV['OAUTH_KEY'],
    :secret => ENV['OAUTH_KEY_SECRET'],
    :options => {
      :site => "http://emma.pixnet.cc",
      :request_token_path => "/oauth/request_token",
      :access_token_path => "/oauth/access_token",
      :authorize_path => "/oauth/authorize"
    }
  }
} unless defined? OAUTH_CREDENTIALS

load 'oauth/models/consumers/service_loader.rb'

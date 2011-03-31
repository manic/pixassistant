class OpenidsController < ApplicationController

  def pixnet
    openid_url = "https://openid.pixnet.cc/id"
    authenticate_with_open_id(openid_url, :required => [:email, :nickname]) do |result, identity_url, registration|
      setup(registration, identity_url)
    end
  end

  def logout
    logout_killing_session!
    redirect_back_or_default('/', :notice => "You have been logged out.")
  end

  protected
  def setup(registration, identity_url)
    user = User.find_by_identity_url(identity_url)
    unless user
      user = User.create_from_pixnet_openid(registration, identity_url)
    end
    self.current_user = user
    redirect_back_or_default('/')
  end

end


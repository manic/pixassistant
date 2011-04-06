class HomeController < ApplicationController
  before_filter :login_required, :only => [:master]

  def index
  end

  def master
    m = User.where(:login => params[:user].to_s).first
    redirect_back_or_default('/') unless m.present?
    if m.id == current_user.id || m.has_assistant?(current_user.login)
      session[:master] = m.id
      session[:master_login] = m.login
    end
    redirect_back_or_default('/')
  end

end

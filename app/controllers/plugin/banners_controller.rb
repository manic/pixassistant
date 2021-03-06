class Plugin::BannersController < ApplicationController

  before_filter :login_required, :except => [:api]
  before_filter :check_master, :except => [:api]
  before_filter :store_location, :only => [:index]
  before_filter :find_banner, :only => [:edit, :update, :destroy]

  def index
    @banners = @master.banners
  end

  def sort
    @master.banners.each do |banner|
      banner.position = params[:banner].index(banner.id.to_s) + 1
      banner.save
    end
    clean_cache(@master)
    render :nothing => true
  end

  def api
    user = User.find_by_login(params[:user].to_s)
    unless user.present? && user.banners.present?
      render_json([].to_json)
      return true
    end
    banners = Rails.cache.fetch("banners_#{user.id}", :expires_in => 10.minute) do
      user.banners.select([:position, :image, :url]).to_json
    end
    render_json(banners)
  end

  def new
    @banner = @master.banners.new
  end

  def create
    @banner = @master.banners.build(params[:banner])
    if @banner.save
      clean_cache(@master)
      redirect_to plugin_banners_path
    end
  end

  def edit
  end

  def update
    @banner.update_attributes(params[:banner])
    clean_cache(@master)
    redirect_to plugin_banners_path
  end

  def destroy
    @banner.destroy
    clean_cache(@master)
    redirect_to plugin_banners_path
  end

  protected

  def find_banner
    @banner = @master.banners.find(params[:id])
  end

  def check_master
    unless session[:master].present? #沒設定就直接指定為本人
      @master = current_user
      return true
    end

    master_id = session[:master] || current_user.id
    assistance = Assistance.where(:master_id => master_id).named(current_user.login).first
    if assistance.present? && assistance.perm_blog_comment
      @master = assistance.master
    elsif master_id == current_user.id
      @master = current_user
    else
      flash[:error] = '無權以此人身份執行此動作。'
      redirect_to('/')
    end
  end

  def clean_cache(user)
    Rails.cache.delete("banners_#{user.id}")
  end

  def render_json(json)
    if params[:callback]
      render :js => "#{params[:callback]}(#{json})"
    else
      render :json => json
    end
  end

end

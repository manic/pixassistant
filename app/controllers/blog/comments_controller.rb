class Blog::CommentsController < ApplicationController

  before_filter :login_required, :check_master
  before_filter :store_location, :only => [:index]

  def index
    if @master.pixnet.present?
      @page = params[:page] ? params[:page].to_i : 1
      @per_page = params[:per_page] ? params[:per_page].to_i : 20
      @filter = params[:filter] || 'nospam'
      args = "?per_page=#{@per_page}&filter=#{@filter}&page=#{@page}"
      ret = JSON.parse(@master.pixnet.client.get("/blog/comments#{args}").body)
      @comments = ret["comments"]
      @total_page = (ret['total'].to_f / @per_page).ceil.to_i
    else
      render "/common/need_connect"
    end
  end

  def reply
    id = params[:id]
    ret = JSON.parse(@master.pixnet.client.post("/blog/comments/#{id}/reply", {:body => params[:body]}).body)
    respond_to do |format|
      format.js { render :json => ret.to_json }
    end
  end

  def destroy_batch
    ids = params[:ids]
    ret = nil
    ids.split(',').each do |id|
      ret = JSON.parse(@master.pixnet.client.post("/blog/comments/#{id}", {:_method => "delete"}).body)
    end
    respond_to do |format|
      format.js { render :json => ret.to_json }
    end
  end

  def mark_spam_batch
    ids = params[:ids]
    ret = nil
    ids.split(',').each do |id|
      ret = JSON.parse(@master.pixnet.client.post("/blog/comments/#{id}/mark_spam").body)
    end
    respond_to do |format|
      format.js { render :json => ret.to_json }
    end
  end

  def mark_ham
    id = params[:id]
    ret = JSON.parse(@master.pixnet.client.post("/blog/comments/#{id}/mark_ham").body)
    respond_to do |format|
      format.js { render :json => ret.to_json }
    end
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

end

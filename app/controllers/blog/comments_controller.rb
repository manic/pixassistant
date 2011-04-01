class Blog::CommentsController < ApplicationController

  before_filter :login_required

  def index
    ret = JSON.parse(current_user.pixnet.client.get('/blog/comments?per_page=10').body)
    @comments = ret["comments"]
  end

  def reply
    id = params[:id]
    ret = JSON.parse(current_user.pixnet.client.post("/blog/comments/#{id}/reply", {:body => params[:body]}).body)
    respond_to do |format|
      format.js { render :json => ret.to_json }
    end
  end

end

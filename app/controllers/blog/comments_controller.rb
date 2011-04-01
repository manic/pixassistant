class Blog::CommentsController < ApplicationController

  before_filter :login_required

  def index
    ret = JSON.parse(current_user.pixnet.client.get('/blog/comments?per_page=10').body)
    @comments = ret["comments"]
  end

end

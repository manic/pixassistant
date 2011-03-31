class AssistancesController < ApplicationController

  before_filter :login_required

  def index
    @assistance = Assistance.new
    @assistances = current_user.assistances
  end

  def create
    @assistance = current_user.assistances.build(params[:assistance])
    if @assistance.save
      redirect_to assistances_path
    end
  end

end

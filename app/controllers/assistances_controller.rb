class AssistancesController < ApplicationController

  before_filter :login_required

  def index
    @new_assistance = Assistance.new
    @assistances = current_user.assistances
  end

  def create
    @assistance = current_user.assistances.build(params[:assistance])
    if @assistance.save
      redirect_to assistances_path
    end
  end

  def show
    @new_assistance = Assistance.new
    @assistances = current_user.assistances
    @assistance = Assistance.find(params[:id])
    render :index
  end

  def update
    @assistance = Assistance.find(params[:id])
    @assistance.update_attributes(params[:assistance])
    redirect_to assistance_path(@assistance)
  end

  def destroy
    @assistance = Assistance.find(params[:id])
    @assistance.destroy
    redirect_to assistances_path
  end

end

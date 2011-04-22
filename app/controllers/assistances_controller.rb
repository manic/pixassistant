class AssistancesController < ApplicationController

  before_filter :login_required
  before_filter :store_location, :only => [:index]
  before_filter :find_assistance, :only => [:update, :destroy]

  def index
    if current_user.pixnet.present?
      @new_assistance = Assistance.new
      @assistances = current_user.assistances
    else
      render "/common/need_connect"
    end
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
    @assistance.update_attributes(params[:assistance])
    redirect_to assistance_path(@assistance)
  end

  def destroy
    @assistance.destroy
    redirect_to assistances_path
  end

  protected
  def find_assistance
    @assistance = Assistance.find(params[:id])
  end
end

class API::UsersController < ApplicationController
  def index
    json_response(User.all)
  end

  def new
    @user = User.new
  end


  def create
    @user = User.find_or_create_by(:name => params[:name])
    json_response(@user)
  end


  def show
  end

  private

  def user_params
    params.require(:user).permit(:name, :latitude, :longitude)
  end
end
  
# Controller for users endpoints
class API::UsersController < ApplicationController
  def index
    @users = User.all
    json_response(@users)
  end

  def create
    @user = User.find_or_create_by(name: params[:name])
    json_response(@user)
  end

  def show
    @user = User.find_by_id(user_params[:id])
    json_response(create_response)
  end

  private

  def user_params
    params.permit(:name, :id)
  end

  def create_response
    {
      name: @user.name,
      bias: {
        libertarian: @user.bias[:libertarian],
        green: @user.bias[:green],
        liberal: @user.bias[:liberal],
        conservative: @user.bias[:conservative]
      },
      read_articles_count: @user.articles.count,
      read_articles: @user.articles
    }
  end
end

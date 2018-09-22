class API::VotesController < ApplicationController

  def index
    Vote.all
  end

  def show
  end

  def create
    @vote = Vote.create(article_id: vote_params[:article_id], user_id: vote_params[:user_id], vote: vote_params[:voted])
    render json: {status: :ok}
  end

  private

  def vote_params
    params.require(:vote).permit(:article_id, :user_id, :voted)
  end
end

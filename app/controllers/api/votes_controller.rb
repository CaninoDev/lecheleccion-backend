class API::VotesController < ApplicationController

  def index
    Vote.all
  end

  def show
  end

  def create
    user = User.find_by_id(vote_params[:user_id])
    article = Article.find_by_id(vote_params[:article_id])
    vote = vote_params[:voted]
    @vote = Vote.where(article_id: article.id, user_id: user.id, vote: vote).first_or_create
    render json: {status: :ok}
  end

  private

  def vote_params
    params.require(:vote).permit(:article_id, :user_id, :voted)
  end
end

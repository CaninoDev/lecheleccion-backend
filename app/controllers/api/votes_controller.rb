class API::VotesController < ApplicationController

  def index
    Vote.all
  end

  def show
  end

  def create
    byebug
    user  = User.find_by_id(vote_params[:user_id])
    article = Article.find_by_id(vote_params[:article_id])
    @vote = Vote.create(article_id: article.id, user_id: user.id, vote: vote_params[:vote])
  end

  private

  def vote_params
    params.permit(:vote, :article_id, :user_id)
  end

end

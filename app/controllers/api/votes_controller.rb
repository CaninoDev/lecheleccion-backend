class API::VotesController < ApplicationController

  @@allVotes = []

  def index
    Vote.all
  end

  def show
  end

  def create
    @vote = Vote.create(article_id: params[:article_id], user_id: params[:user_id], vote: params[:vote])
    @user = User.find_by_id(params[:user_id])
    @article
  end

end

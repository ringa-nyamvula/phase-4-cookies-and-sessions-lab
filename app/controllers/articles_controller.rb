class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  before_action :authenticate_user, only: [:show]
  before_action :authorize_user, only: [:show]

  def index
    articles = Article.all
    render json: articles
  end
  before_action :authenticate_user, only: [:show]
  before_action :authorize_user, only: [:show]
  def show
    article = Article.find(params[:id])

    # Increment page_views if it exists in the session, or set it to 0 if it doesn't exist
    session[:page_views] ||= 0
    session[:page_views] += 1

    if session[:page_views] <= 3
      render json: article
    else
      render json: { error: 'Paywall activated. Subscribe for unlimited access.' }, status: :unauthorized
    end
  end 
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end

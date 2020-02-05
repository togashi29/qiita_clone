class Api::V1::ArticlesController < Api::V1::ApiController
  before_action :authenticate_user!, only: [:create, :update, :destroy]

  def index
    articles = Article.published
    render json: articles
  end

  def show
    article = Article.published.find(params[:id])
    render json: article
  end

  def create
    article = current_user.articles.create!(article_params)
    render json: article
  end

  def update
    article = set_article_of_current_user
    article.update!(article_params)
    render json: article
  end

  def destroy
    article = set_article_of_current_user
    article.destroy!
  end

  private

    def article_params
      params.require(:article).permit(:title, :body, :status)
    end

    def set_article_of_current_user
      current_user.articles.find(params[:id])
    end
end

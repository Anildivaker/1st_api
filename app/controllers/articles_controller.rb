class ArticlesController < ApplicationController
	before_action :get_article, only:[:show, :update, :destroy]

	def index
		@articles = Article.page(params[:page]).per(params[:per_page])
		# @articles = Article.paginate(page: params[:page], per_page: 5)
		render json: { article: ActiveModelSerializers::SerializableResource.new(@articles, each_serializer: ArticleSerializer)}, status: :ok	
	end

	def show 
		article = {id: @article.id, title: @article.title, body: @article.body, 
			image: request.base_url + Rails.application.routes.url_helpers.rails_blob_url(@article.image, only_path: true)}
		render json: { article: ArticleSerializer.new(@article, {})}, status: :ok		
	end

	def create
		@article =Article.new(article_params)
		if @article.save
			render json: { article: ArticleSerializer.new(@article, {})}, status: :ok
		else
			render json: {errors: @article.errors}, status: :unprocessable_entity
		end
	end

	def update
	
		if @article.update(article_params)
			render json: { article: ArticleSerializer.new(@article, {})}, status: :ok
		else
			render json: {errors: @article.errors}, status: :unprocessable_entity
		end
	end

	def destroy		
		if @article.destroy
			render json:{message: "successfully destroy"}, status: :ok
		else
			render json: {errors: @article.errors}, status: :unprocessable_entity
		end
	end


	private
	def article_params
		params.require(:article).permit(:title, :body, :image)
	end

	def get_article
		@article = Article.find_by(id:params[:id])
		unless @article.present?
			render json: {error: "not found"}, status: :not_found
		end
	end
end



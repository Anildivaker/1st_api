class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :image
  def image 
    Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true) if object.image.attached?
  end
end

class PostForm
  include ActiveModel::Model

  #PostFormクラスのオブジェクトがPostモデルの属性を扱えるようにする
  attr_accessor(
    :text, :image,
    :id, :created_at, :updated_at,
    :tag_name
    )

  with_options presence: true do
    validates :text
    validates :image
  end

  def save
    post = Post.create(text: text, image: image)
    if tag_name.present?
      tag = Tag.where(tag_name: tag_name).first_or_initialize
      tag.save
      PostTagRelation.create(post_id: post.id, tag_id: tag.id)
    end
  end

  def update(params, post)
    post.update(params)
  end
end
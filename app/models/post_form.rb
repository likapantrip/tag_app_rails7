class PostForm
  include ActiveModel::Model

  #PostFormクラスのオブジェクトがPostモデルの属性を扱えるようにする
  attr_accessor(
    :text, :image,
    :id, :created_at, :updated_at,
    :tag_name
  )

  # Postモデルのバリデーション
  with_options presence: true do
    validates :text
    validates :image
  end

  # フォームから送られてきた情報をテーブルに保存する処理
  def save
    #Post.create(text: text, image: image)
    post = Post.create(text: text, image: image) # 保存したpostのレコードを変数postに代入
    if tag_name.present?
      tag = Tag.where(tag_name: tag_name).first_or_initialize # tagが重複して保存されることを防ぐため、first_or_initializeメソッドを使用
      tag.save
      PostTagRelation.create(post_id: post.id, tag_id: tag.id) # tagとpostの紐付けの情報を、中間テーブルに保存
    end
  end

  # フォームから送られてきた情報を使用して、レコードを更新する処理
  def update(params, post)
    #post.update(params)
    
    #一度タグの紐付けを消す
    post.post_tag_relations.destroy_all

    #paramsの中のタグの情報を削除。同時に、返り値としてタグの情報を変数に代入
    tag_name = params.delete(:tag_name)

    #もしタグの情報がすでに保存されていればインスタンスを取得、無ければインスタンスを新規作成
    tag = Tag.where(tag_name: tag_name).first_or_initialize if tag_name.present?

    #タグを保存
    tag.save if tag_name.present?
    post.update(params)
    PostTagRelation.create(post_id: post.id, tag_id: tag.id) if tag_name.present?
  end
end
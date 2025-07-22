class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update]

  def index
    @posts = Post.all
  end

  def new
    @post_form = PostForm.new
  end

  def create
    @post_form = PostForm.new(post_form_params)
    if @post_form.valid?
      @post_form.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @postから情報をハッシュとして取り出す
    post_attributes = @post.attributes
    # @post_formとしてインスタンス生成
    @post_form = PostForm.new(post_attributes)
    # tagがあれば、入力フォームにタグ名を表示
    @post_form.tag_name = @post.tags.first&.tag_name
  end

  def update
    # paramsの内容を反映したインスタンスを生成する
    @post_form = PostForm.new(post_form_params)

    # 画像を選択し直していない場合は、既存の画像をセットする
    @post_form.image ||= @post.image.blob

    if @post_form.valid?
      # バリデーションに問題なければ、値を更新
      @post_form.update(post_form_params, @post)
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def search
    # フォームの入力内容が空であれば、Javascriptにnilを返す
    return nil if params[:keyword] == ""
    # フォームの入力内容をもとに、あいまい検索。DB内に一致するものがあれば、変数tagに情報を代入
    tag = Tag.where(['tag_name LIKE ?', "%#{params[:keyword]}%"] )
    # json形式で、変数tagの情報をJavascriptに返す
    render json:{ keyword: tag }
  end

  private
  def post_form_params
    params.require(:post_form).permit(:text, :tag_name, :image)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end

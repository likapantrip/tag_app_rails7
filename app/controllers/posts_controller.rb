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
    # @postから情報をハッシュとして取り出し、@post_formとしてインスタンス生成する
    post_attributes = @post.attributes
    @post_form = PostForm.new(post_attributes)
    @post_form.tag_name = @post.tags.first&.tag_name
  end

  def update(params, post)
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

  private
  def post_form_params
    params.require(:post_form).permit(:text, :tag_name, :image)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end

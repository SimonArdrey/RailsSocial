class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, except: [:index, :create]
  before_action :set_new_post, only: [:index, :new]
  before_action :set_postable

  layout "posts"

  def index
    @default_layout_title = "Posts"

    if @postable
      @posts = BuildPostsFeed.run!({ viewing_user: current_user, postable: @postable, page: params[:page] })
    else
      @posts = BuildPostsFeed.run!({ viewing_user: current_user, author_user: current_user })
    end
  end

  def show
    @default_layout_title = "Post"
  end

  def new
    @default_layout_title = "Write Post"
  end

  def edit
    @default_layout_title = "Edit Post"
  end

  def create
    @post = Post.new(post_params)
    # Set author
    @post.user = current_user

    respond_to do |format|
      if @postable.posts << @post
        format.html { redirect_to [@postable, @post], notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to [@postable, @post], notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @post.user != current_user
      respond_to do |format|
        format.html { redirect_to [@postable, @post], error: 'Forbidden.' }
        format.json { render json: @post.errors, status: :forbidden }
      end
    else
      @post.destroy
      respond_to do |format|
        format.html { redirect_to [@postable, Post] }
        format.json { head :no_content }
      end
    end
  end

  def like
    if PostRating.where(user: current_user, post: @post, kind: 'like').empty?
      PostRating.create!(user: current_user, post: @post, kind: 'like', value: 1)
    end

    respond_to do |format|
      format.html { redirect_to [@postable, @post], notice: "You just liked a Post" }
      format.js { render 'like' }
    end
  end

  def unlike
    if PostRating.where(user: current_user, post: @post, kind: 'like').exists?
      PostRating.where(user: current_user, post: @post, kind: 'like').destroy_all
    end

    respond_to do |format|
      format.html { redirect_to [@postable, @post], notice: "You just unliked a Post" }
      format.js { render 'like' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post
      .includes(:postable)
      .find(params[:id].to_i)
  end

  def set_new_post
    @post = Post.new
    @post.user = current_user

    kind = (params.has_key?(:kind) and Post.kinds.has_key?(params[:kind].to_sym)) ? params[:kind] : 'basic'
    @post.kind = kind
  end

  def set_postable
    if params[:postable_type] and params[:postable_param]
      @postable_class = params[:postable_type].capitalize.constantize
      @postable = @postable_class.find(params[params[:postable_param]])
    elsif params[:postable_type] and params[:postable_id]
      @postable_class = params[:postable_type].capitalize.constantize
      @postable = @postable_class.find(params[:postable_id])
    end
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end

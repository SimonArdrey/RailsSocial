class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
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
  end

  def unlike
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

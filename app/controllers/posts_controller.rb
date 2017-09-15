class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_postable
  layout 'profile'

  def index
    @posts = Post.all
  end

  def show
  end

  def new
    @post = Post.new
  end

  def edit
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  def get_postable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

  def set_postable
    # if params[:postable_type]
    #  @postable_class = params[:postable_type].capitalize.constantize
    # end

    # if params[:user_id]
    #   @postable = User.find(params[:user_id])
    # else
    #   # Default to current users wall.
    #   @postable = current_user;
    # end

    @postable = get_postable;
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end

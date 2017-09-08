class PostsController < InheritedResources::Base
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_postable

  def index
    @posts = Post.all
    puts @postable_type
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
    @post.user = current_user

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Test was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(test_params)
        format.html { redirect_to @post, notice: 'Test was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to tests_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def set_postable
      @modelClass = params[:postable_type].capitalize.constantize

      if params[:user_id]
        postable_id = params[:user_id]
      end
      
      @postable = modelClass.find(posable_id)
    end

    def post_params
      params.require(:body).permit(:title)
    end
end

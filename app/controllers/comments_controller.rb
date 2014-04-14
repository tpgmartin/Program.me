class CommentsController < ApplicationController
  load_and_authorize_resource
  before_filter :load_commentable

  def index
    @comments = @commentable.comments.order("created_at desc")#.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    # @comment = Comment.find(params[:id])
  end

  def new
    @comment = @commentable.comments.new#(:parent_id => params[:parent_id])
  end

  def create
    @comment = @commentable.comments.new(params[:comment])
    @comment.user_id = params[:user_id]
    @comment.event_id = params[:event_id]    
    if @comment.save
      @comment.create_activity :create, owner: current_user
      redirect_to @commentable, notice: "Comment created."
    else
      render :new
    end
  end

  private

  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  # def load_commentable
  #   params.each do |name, value|
  #     return @commentable = $1.classify.constantize.find(value) if name =~ /(.+)_id$/
  #   end
  # end

end
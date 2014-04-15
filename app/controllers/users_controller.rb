class UsersController < ApplicationController
  # after_filter :check_signup
  load_and_authorize_resource

  @@connections = []

  skip_before_action :check_relations, only: [:new, :create] 
  skip_before_action :check_inverse_relations, only: [:new, :create]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @activities = PublicActivity::Activity.order("created_at desc").where(owner_id: current_user.relation_ids << current_user.id << @@connections, owner_type: "User")#.paginate(:page => params[:page], :per_page => 10)
    @commentable = @user
    @comments = @commentable.comments
    @comment = Comment.new  
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      UserMailer.signup_confirmation(@user).deliver
      # UserMailer.student_parent_signup(@user, token).deliver Need to update this user mailer call
      @user.create_activity :create, owner: current_user
      cookies[:auth_token] = @user.auth_token
      redirect_to @user, notice: "Thank you for signing up!"
    else
      render "new"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end

  private

  def check_relations
    current_user.relations.each do |relation|
      @@connections << relation.id
    end
  end

  def check_inverse_relations
    current_user.inverse_relations.each do |inverse_relation|
      @@connections << inverse_relation.id
    end

  end

  # def check_signup
  #   authenticate_or_request_with_http_token do |token, options|
  #     User.exists?(token: token)
  #   end
  # end
end

class EventsController < ApplicationController
  load_and_authorize_resource
  before_filter :authorize, only: [:edit, :update]

  def index
    @event = Event.all
    @events_by_date = @event.group_by(&:date) # Want to change &:date 
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end

  def show
    @event = Event.find(params[:id])
    @commentable = @event
    @comments = @commentable.comments
    @comment = Comment.new  
    Reading.where(user_id: current_user.id).where(event_id: @event.id).delete_all
  end

  def new
    @user = current_user
    @contacts = current_user.inverse_relations | current_user.relations
    @relationships = Relationship.where(user_id: current_user.id)
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event])    
    recipient = User.where(email: @event.recipient_email)[0] || []
    @event.users << current_user << recipient
    @user = current_user
    if @event.save
      @event.create_activity :create, owner: current_user
      UserMailer.event_creation(@user, @event, event_url(@event)).deliver
      Reading.create(user_id: current_user.id, event_id: @event.id)
      redirect_to current_user, notice: "Event created."
    else
      render :new
    end
  end

  def edit
    @contacts = current_user.inverse_relations & current_user.relations
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    @event.users << current_user
    if @event.update_attributes(params[:event])
      @event.create_activity :update, owner: current_user
      redirect_to events_url, notice: 'Event updated.'
    else
      render action: "edit" 
    end
  end
  
  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    # @event.create_activity :destroy, owner: current_user
    redirect_to events_url, notice: 'Event deleted' 
  end
end

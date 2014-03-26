class ActivitiesController < ApplicationController
  def index
    @activities = PublicActivity::Activity.order("created_at desc").where(owner_id: current_user.relation_ids, owner_type: "User").page(params[:page])
  end

  def destroy

    # @comment = current_user.comments.find(params[:id])
    @activity = PublicActivity::Activity.find_by_id(params[:id])
    @activity.destroy
    # @comment.destroy
    flash[:notice] = "Successfully removed activity."
    redirect_to current_user
  end

  # def destroy
  #   @event = Event.find(params[:id])
  #   @event.destroy
  #   @event.create_activity :destroy, owner: current_user
  #   redirect_to events_url 
  # end
end

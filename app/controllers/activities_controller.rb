class ActivitiesController < ApplicationController
  def index
    @activities = PublicActivity::Activity.order("created_at desc").where(owner_id: current_user.relation_ids, owner_type: "User").page(params[:page])
  end

  def destroy
    @activities = PublicActivity::Activity.order("created_at desc").where(owner_id: current_user.relation_ids, owner_type: "User").page(params[:page])
    @activity = activities.find(params[:id])
    @activity.destroy
    # @activity.create_activity :destroy, owner: current_user
    flash[:notice] = "Successfully removed activity."
  end

  # def destroy
  #   @event = Event.find(params[:id])
  #   @event.destroy
  #   @event.create_activity :destroy, owner: current_user
  #   redirect_to events_url 
  # end
end

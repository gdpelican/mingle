class Admin::MinglesController < ApplicationController
  def reschedule
    Mingle::Scheduler.new.reschedule!(at: Time.zone.parse(params.require(:at)))
    render json: { success: :ok }
  end

  def scheduled
    respond_with_time
  end

  private

  def respond_with_time
    render json: { at: Mingle::Scheduler.new.current_job_time }
  end
end

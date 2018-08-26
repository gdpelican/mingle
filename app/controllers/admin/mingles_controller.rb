class Admin::MinglesController < ApplicationController
  def reschedule
    Mingle::Scheduler.new.reschedule!(refresh: true, at: Time.zone.parse(params.require(:at)))
    respond_with_time
  end

  def scheduled
    respond_with_time
  end

  private

  def respond_with_time
    render json: { at: Mingle::Scheduler.new.current_job_time }
  end
end

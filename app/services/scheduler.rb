module Mingle
  class Scheduler
    def reschedule!
      byebug
      unschedule!
      Jobs.enqueue_in(next_job_time, :mingle) if SiteSetting.mingle_enabled
    end

    def unschedule!
      Sidekiq::ScheduledSet.new.select { |j| j.queue == 'mingle' }.map(&:delete)
    end

    private

    def next_job_time
      SiteSetting.mingle_interval_number.send(SiteSetting.mingle_interval_type)
    end
  end
end

module Mingle
  class Scheduler
    def reschedule!(refresh: false)
      SiteSetting.refresh! if refresh
      unschedule!
      if SiteSetting.mingle_enabled
        Rails.logger.info "Rescheduling next mingle for #{SiteSetting.mingle_interval_number} #{SiteSetting.mingle_interval_type} from now"
        Jobs.enqueue_in(next_job_time, :mingle)
      else
        Rails.logger.info "Mingle has been disabled, next mingle has not been scheduled"
      end
    end

    def unschedule!
      Sidekiq::ScheduledSet.new.select { |j| j.item['class'] == 'Jobs::Mingle' }.map(&:delete)
    end

    private

    def next_job_time
      SiteSetting.mingle_interval_number.send(SiteSetting.mingle_interval_type)
    end
  end
end

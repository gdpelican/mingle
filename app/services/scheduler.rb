module Mingle
  class Scheduler
    def reschedule!(at:)
      unschedule!
      if SiteSetting.mingle_enabled
        Rails.logger.info "Rescheduling next mingle for #{SiteSetting.mingle_interval_number} #{SiteSetting.mingle_interval_type} from now"
        Jobs.enqueue_at(at, :mingle)
        MessageBus.publish '/mingle', { at: at }
      else
        Rails.logger.info "Mingle has been disabled, next mingle has not been scheduled"
      end
    end

    def unschedule!
      current_job&.delete
    end

    def current_job_time
      current_job&.at
    end

    private

    def current_job
      Sidekiq::ScheduledSet.new.detect { |j| j.item['class'] == 'Jobs::Mingle' }
    end
  end
end

module Jobs
  class Mingle < ::Jobs::Base
    sidekiq_options queue: :low

    def execute(args = {})
      return if !SiteSetting.mingle_enabled
      return log_mismingle unless mingle_sets.presence
      mingle_sets.each { |pair| ::Mingle::Sender.new(pair.compact).send! }
    ensure
      at = SiteSetting.mingle_interval_number.send(SiteSetting.mingle_interval_type).from_now
      ::Mingle::Scheduler.new.reschedule!(at: at)
    end

    private

    def mingle_sets
      @mingle_sets ||= ::Mingle::Mixer.new(mingle_users).mix!
    end

    def mingle_users
      @mingle_users ||= User.distinct.joins(:groups).where("groups.name": SiteSetting.mingle_group_name.split('|'))
    end


    def log_mismingle
      Rails.logger.warn "No pairs generated from Mingle, group name(s) were '#{SiteSetting.mingle_group_name}'. Are you sure that at least one group exists and has members in it?" if mingle_users.empty?
    end
  end
end

# name: mingle
# about: Icebreaker plugin for Discourse
# version: 0.0.1
# authors: James Kiesel (gdpelican)
# url: https://github.com/gdpelican/mingle

enabled_site_setting :mingle_enabled

def mingle_require(path)
  require Rails.root.join('plugins', 'mingle', 'app', path).to_s
end

mingle_require 'extras/interval_options'

after_initialize do
  mingle_require 'jobs/regular/mingle'
  mingle_require 'services/initializer'
  mingle_require 'services/mixer'
  mingle_require 'services/scheduler'
  mingle_require 'services/sender'

  Mingle::Initializer.new.initialize!

  DiscourseEvent.on(:site_setting_saved) do |setting|
    Mingle::Scheduler.new.reschedule! if [
      "mingle_enabled",
      "mingle_interval_type",
      "mingle_interval_number"
    ].include?(setting.name.to_s)
  end
end

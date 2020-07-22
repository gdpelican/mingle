# name: mingle
# about: Icebreaker plugin for Discourse
# version: 0.1.0
# authors: James Kiesel (gdpelican)
# url: https://github.com/gdpelican/mingle

enabled_site_setting :mingle_enabled

MINGLE_SITE_SETTINGS = [
  "mingle_enabled",
  "mingle_interval_type",
  "mingle_interval_number"
].freeze

def mingle_require(path)
  require Rails.root.join('plugins', 'mingle', 'app', path).to_s
end

register_asset 'stylesheets/mingle.scss'
mingle_require 'extras/interval_options'
mingle_require 'extras/theme_component_seed'

after_initialize do
  mingle_require 'controllers/admin/mingles_controller'
  mingle_require 'jobs/regular/mingle'
  mingle_require 'services/initializer'
  mingle_require 'services/mixer'
  mingle_require 'services/scheduler'
  mingle_require 'services/sender'

  Mingle::ThemeComponentSeed.new.seed!
  Mingle::Initializer.new.initialize!

  Discourse::Application.routes.append do
    namespace :admin, constraints: StaffConstraint.new do
      get  "mingle/scheduled"  => "mingles#scheduled"
      post "mingle/reschedule" => "mingles#reschedule"
    end
  end

  DiscourseEvent.on(:site_setting_changed) do |setting|
    if MINGLE_SITE_SETTINGS.include?(setting.name.to_s)
      SiteSetting.refresh!
      at = SiteSetting.mingle_interval_number.send(SiteSetting.mingle_interval_type).from_now
      Mingle::Scheduler.new.reschedule!(at: at)
    end
  end
end

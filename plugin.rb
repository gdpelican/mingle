# name: mingle
# about: Icebreaker plugin for Discourse
# version: 0.1.0
# authors: James Kiesel (gdpelican)
# url: https://github.com/gdpelican/mingle

enabled_site_setting :mingle_enabled

def mingle_require(path)
  require Rails.root.join('plugins', 'mingle', 'app', path).to_s
end

register_asset 'stylesheets/mingle.scss'
mingle_require 'extras/interval_options'

after_initialize do
  mingle_require 'controllers/admin/mingles_controller'
  mingle_require 'jobs/regular/mingle'
  mingle_require 'services/initializer'
  mingle_require 'services/mixer'
  mingle_require 'services/scheduler'
  mingle_require 'services/sender'

  Mingle::Initializer.new.initialize!

  Discourse::Application.routes.append do
    namespace :admin, constraints: StaffConstraint.new do
      get  "mingle/scheduled"  => "mingles#scheduled"
      post "mingle/reschedule" => "mingles#reschedule"
    end
  end

  DiscourseEvent.on(:site_setting_saved) do |setting|
    Mingle::Scheduler.new.reschedule!(refresh: true) if [
      "mingle_enabled",
      "mingle_interval_type",
      "mingle_interval_number"
    ].include?(setting.name.to_s)
  end
end

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
  mingle_require 'jobs/scheduled/mingle'
  mingle_require 'services/initializer'
  mingle_require 'services/mixer'
  mingle_require 'services/sender'

  Mingle::Initializer.new.initialize!
end

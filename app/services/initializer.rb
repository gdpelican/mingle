module Mingle
  class Initializer
    def reinitialize!
      mingle_post&.topic&.destroy
      mingle_post&.destroy
      self.class.new.initialize!
    end

    def initialize!
      return if mingle_post
      create_mingle_post!
      mingle_post.topic.update_status('closed', true, Discourse.system_user)
      SiteSetting.set('mingle_post_id', mingle_post.id)
    end

    def mingle_post
      @mingle_post ||= Post.find_by(id: SiteSetting.mingle_post_id)
    end

    def create_mingle_post!
      @mingle_post ||= PostCreator.create!(
        Discourse.system_user,
        category:         Category.find_by(slug: :staff)&.id,
        title:            I18n.t("mingle.default_title"),
        raw:              I18n.t("mingle.default_message"),
        skip_validations: true
      )
    end
  end
end

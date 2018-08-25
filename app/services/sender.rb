module Mingle
  Sender = Struct.new(:users) do
    REMOVE_TUTORIAL = /^[\s\S]*------------------[\n]*/
    SUBSTITUTION    = /%{.+?}/
    PARE_MATCH      = /%{(.+?)}/

    def send!
      PostCreator.create!(
        User.find_by(id: SiteSetting.mingle_delivery_user_id),
        title:            process_substitutions(mingle_post.topic.title),
        raw:              process_substitutions(mingle_post.raw),
        archetype:        Archetype.private_message,
        target_usernames: users.map(&:username),
        skip_validations: true
      ) if mingle_post.presence && Array(users).length > 1
    end

    private

    def mingle_post
      @mingle_post ||= Post.find_by(id: SiteSetting.mingle_post_id)
    end

    def process_substitutions(text)
      text.gsub!(REMOVE_TUTORIAL, "")
      text.scan(SUBSTITUTION).uniq.reduce(text) { |str, match| substitute(str, match) }
    end

    def substitute(str, match)
      index, *methods = PARE_MATCH.match(match)[1].split('.')
      str.gsub match, methods.reduce(users[index.to_i - 1]) do |value, method|
        value_from(value, method)
      end.to_s
    end

    def value_from(value, method)
      case value
      when Hash     then value[method]
      when NilClass then value
      else               value.send(method)
      end
    end
  end
end

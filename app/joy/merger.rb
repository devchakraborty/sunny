module Joy
  class Merger
    @graph = Koala::Facebook::API.new(ENV['FB_ACCESS_TOKEN'])

    def self.merge(fb_id, context, entities, message)
      user = User.find_by(fb_id: fb_id)
      unless user.present?
        user = Merger.create_user(fb_id)
      end

      context.merge!(user.context)
      user.update(context: context)

      entities.each do |entity_key, guesses|
        context["just_expressed_#{entity_key}".to_sym] = guesses[0]["value"]
      end
      return context
    end

    private

    def self.create_user(fb_id)
      profile = @graph.get_object(fb_id).with_indifferent_access
      User.create(
        fb_id: fb_id,
        first_name: profile[:first_name],
        last_name: profile[:last_name],
        gender: profile[:gender],
        locale: profile[:locale],
        timezone: profile[:timezone],
        context: { # add more as needed
          first_name: profile[:first_name]
        }
      )
    end
  end
end

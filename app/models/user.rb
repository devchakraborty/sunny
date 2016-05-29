class User < ActiveRecord::Base
  has_many :moments, dependent: :destroy

  @graph = Koala::Facebook::API.new(ENV['FB_ACCESS_TOKEN'])

  def self.create_for_fb_id(fb_id)
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

  def self.find_or_create_by_fb_id(fb_id)
    user = User.find_by(fb_id: fb_id)
    user.nil? ? User.create_for_fb_id(fb_id) : user
  end
end

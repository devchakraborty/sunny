class MomentStorer
  def self.store(fb_id, text, at)
    User.find_by(fb_id: fb_id).moments.create(text: text, entered_at: Time.at(at))
  end
end

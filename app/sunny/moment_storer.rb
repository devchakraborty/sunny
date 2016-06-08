class MomentStorer
  def self.store(fb_id, text)
    User.find_by(fb_id: fb_id).moments.create(text: text)
  end
end

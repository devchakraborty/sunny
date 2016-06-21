class MomentStorer
  def self.store(fb_id, text, at, attachments=[])
    attachments = attachments.select do |attachment|
      ["image", "audio", "video"].include? attachment["type"]
    end
    User.find_by(fb_id: fb_id).moments.create(text: text, entered_at: Time.at(at), attachments: attachments)
  end
end

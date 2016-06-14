class Moment < ActiveRecord::Base
  belongs_to :user

  scope :created_by, -> (fb_id) { includes(:user).where(users: {fb_id: fb_id}) }
  scope :entered_between, -> (from, to) { where("moments.entered_at >= ? AND moments.entered_at <= ?", from, to) }
  scope :shuffled, -> { order('random()') }
end

class Moment < ActiveRecord::Base
  belongs_to :user

  scope :created_by, -> (fb_id) { includes(:user).where(users: {fb_id: fb_id}) }
  scope :created_between, -> (from, to) { where("moments.created_at >= ? AND moments.created_at <= ?", from, to) }
  scope :shuffled, -> { order('random()') }
end

class AddSentimentScoreToMoments < ActiveRecord::Migration
  def change
    change_table :moments do |t|
      t.decimal :sentiment_score, null: false, default: 0.5
    end
  end
end

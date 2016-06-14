class AddEnteredAtToMoments < ActiveRecord::Migration
  def change
    change_table :moments do |t|
      t.datetime :entered_at, null: false
    end
  end
end

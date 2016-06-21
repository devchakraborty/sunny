class AddAttachmentsToMoments < ActiveRecord::Migration
  def change
    change_table :moments do |t|
      t.jsonb :attachments, null: false, default: []
    end
  end
end

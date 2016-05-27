class CreateMoments < ActiveRecord::Migration
  def change
    create_table :moments do |t|
      t.string :text
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fb_id, null: false
      t.string :first_name
      t.string :last_name
      t.integer :timezone
      t.string :gender
      t.string :locale

      t.timestamps null: false
      t.index :fb_id
    end
  end
end

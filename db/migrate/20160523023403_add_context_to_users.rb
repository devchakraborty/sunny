class AddContextToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.jsonb :context, null: false, default: {}
    end
  end
end

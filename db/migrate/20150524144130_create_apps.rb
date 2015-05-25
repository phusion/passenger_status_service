class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.integer :user_id, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.string :name, null: false
      t.string :api_token, null: false
      t.timestamps null: false
    end

    add_index :apps, :api_token, unique: true
  end
end

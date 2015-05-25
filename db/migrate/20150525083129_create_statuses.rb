class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.integer :app_id, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.string :hostname, null: false
      t.text :content, null: false
      t.timestamps null: false
    end
  end
end

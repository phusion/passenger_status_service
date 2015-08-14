class CreateHosts < ActiveRecord::Migration
  def up
    create_table :hosts do |t|
      t.integer :app_id, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.string :hostname, null: false
      t.timestamps null: false
    end
    add_index :hosts, [:app_id, :hostname], unique: true

    execute "INSERT INTO hosts (app_id, hostname, created_at, updated_at) " +
      "SELECT app_id,hostname,NOW(),NOW() FROM statuses GROUP BY app_id,hostname"

    add_column :statuses, :host_id, :integer, foreign_key: { on_update: :cascade, on_delete: :cascade }

    execute "UPDATE statuses SET host_id = hosts.id " +
      "FROM hosts WHERE statuses.hostname = hosts.hostname"

    change_column :statuses, :host_id, :integer, null: false,
      foreign_key: { on_update: :cascade, on_delete: :cascade }
    remove_column :statuses, :hostname
    add_index :statuses, [:host_id, :updated_at]

    remove_column :statuses, :app_id
  end

  def down
    add_column :statuses, :app_id, :integer, foreign_key: { on_update: :cascade, on_delete: :cascade }
    execute "UPDATE statuses SET app_id = hosts.app_id " +
      "FROM hosts WHERE statuses.host_id = hosts.id"
    change_column :statuses, :app_id, :integer, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }

    add_column :statuses, :hostname, :string
    execute "UPDATE statuses SET hostname = hosts.hostname " +
      "FROM hosts WHERE statuses.host_id = hosts.id"
    change_column :statuses, :hostname, :string, null: false
    remove_column :statuses, :host_id

    add_index :statuses, [:app_id, :hostname, :updated_at], name: "statuses_index_on_3columns"
    drop_table :hosts
  end
end

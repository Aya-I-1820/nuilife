# db/migrate/20250819123625_add_devise_fields_to_users.rb
class AddDeviseFieldsToUsers < ActiveRecord::Migration[7.1]
  def up
    return unless table_exists?(:users)

    # email（DeviseCreateUsers で作られている想定。無ければ追加）
    add_column :users, :email, :string, null: false, default: "" unless column_exists?(:users, :email)

    # encrypted_password（必須）
    add_column :users, :encrypted_password, :string, null: false, default: "" unless column_exists?(:users, :encrypted_password)

    # Recoverable
    add_column :users, :reset_password_token,   :string   unless column_exists?(:users, :reset_password_token)
    add_column :users, :reset_password_sent_at, :datetime unless column_exists?(:users, :reset_password_sent_at)

    # Rememberable
    add_column :users, :remember_created_at, :datetime    unless column_exists?(:users, :remember_created_at)

    # Index
    add_index :users, :email,                unique: true unless index_exists?(:users, :email)
    add_index :users, :reset_password_token, unique: true unless index_exists?(:users, :reset_password_token)
  end

  def down
    return unless table_exists?(:users)

    # Index を先に外す
    remove_index :users, :reset_password_token if index_exists?(:users, :reset_password_token)
    remove_index :users, :email                if index_exists?(:users, :email)

    # 追加した可能性のあるカラムを安全に戻す
    remove_column :users, :remember_created_at      if column_exists?(:users, :remember_created_at)
    remove_column :users, :reset_password_sent_at   if column_exists?(:users, :reset_password_sent_at)
    remove_column :users, :reset_password_token     if column_exists?(:users, :reset_password_token)
    remove_column :users, :encrypted_password       if column_exists?(:users, :encrypted_password)
    remove_column :users, :email                    if column_exists?(:users, :email)
  end
end

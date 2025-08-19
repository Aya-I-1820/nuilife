# db/migrate/xxxxxxxxxxxxxx_add_devise_fields_to_users.rb
class AddDeviseFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    # email
    if column_exists?(:users, :email)
      change_column_default :users, :email, ""
      change_column_null    :users, :email, false, ""
    else
      add_column :users, :email, :string, null: false, default: ""
    end

    # encrypted_password（必須）
    unless column_exists?(:users, :encrypted_password)
      add_column :users, :encrypted_password, :string, null: false, default: ""
    else
      change_column_default :users, :encrypted_password, ""
      change_column_null    :users, :encrypted_password, false, ""
    end

    # Recoverable
    add_column :users, :reset_password_token,   :string  unless column_exists?(:users, :reset_password_token)
    add_column :users, :reset_password_sent_at, :datetime unless column_exists?(:users, :reset_password_sent_at)

    # Rememberable
    add_column :users, :remember_created_at, :datetime   unless column_exists?(:users, :remember_created_at)

    # Index
    add_index :users, :email,                unique: true unless index_exists?(:users, :email)
    add_index :users, :reset_password_token, unique: true unless index_exists?(:users, :reset_password_token)

    # もし has_secure_password を使っていた名残で password_digest があるなら残してOK（Deviseは使いません）
  end
end

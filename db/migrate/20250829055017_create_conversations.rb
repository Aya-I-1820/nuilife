# db/migrate/xxxx_create_conversations.rb
class CreateConversations < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations do |t|
      t.integer :user1_id, null: false
      t.integer :user2_id, null: false
      t.timestamps
    end
    add_index :conversations, [:user1_id, :user2_id], unique: true
    add_index :conversations, :user1_id
    add_index :conversations, :user2_id
  end
end

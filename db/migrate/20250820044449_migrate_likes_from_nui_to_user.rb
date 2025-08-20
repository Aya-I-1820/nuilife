# db/migrate/XXXXXXXXXXXX_migrate_likes_from_nui_to_user.rb
class MigrateLikesFromNuiToUser < ActiveRecord::Migration[7.1]
  def up
    # 1) user_id を一時的に NULL 許可で追加（後で NOT NULL にする）
    add_reference :likes, :user, null: true, foreign_key: true unless column_exists?(:likes, :user_id)

    # 2) 既存の likes.nui_id から user_id を埋める
    #    SQLite でも使える相関サブクエリで一括更新
    execute <<~SQL
      UPDATE likes
      SET user_id = (
        SELECT user_id FROM nuis WHERE nuis.id = likes.nui_id
      )
      WHERE user_id IS NULL
    SQL

    # 3) NOT NULL 制約を付ける
    change_column_null :likes, :user_id, false

    # 4) 二重いいね防止のユニーク制約
    add_index :likes, [:user_id, :post_id], unique: true unless index_exists?(:likes, [:user_id, :post_id], unique: true)

    # 5) 旧カラムを削除（外部キーやインデックスがあるなら一緒に）
    remove_index :likes, :nui_id if index_exists?(:likes, :nui_id)
    remove_column :likes, :nui_id if column_exists?(:likes, :nui_id)
  end

  def down
    # 逆マイグレーション（必要なら）
    add_reference :likes, :nui, null: true, foreign_key: true unless column_exists?(:likes, :nui_id)

    execute <<~SQL
      UPDATE likes
      SET nui_id = (
        SELECT id FROM nuis WHERE nuis.user_id = likes.user_id
        LIMIT 1
      )
      WHERE nui_id IS NULL
    SQL

    change_column_null :likes, :nui_id, false
    remove_index :likes, [:user_id, :post_id] if index_exists?(:likes, [:user_id, :post_id], unique: true)
    remove_column :likes, :user_id if column_exists?(:likes, :user_id)
  end
end

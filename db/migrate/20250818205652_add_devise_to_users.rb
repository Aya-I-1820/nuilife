# db/migrate/20250818205652_add_devise_to_users.rb
class AddDeviseToUsers < ActiveRecord::Migration[7.1]
  def up
    return unless table_exists?(:users)
    # ここは今回ノーオペ（既に DeviseCreateUsers で必要カラムは作成済み）
    # もし本当に追加が必要なカラムがあるなら、column_exists? を使って足してください。
  end

  def down
    # ノーオペ
  end
end

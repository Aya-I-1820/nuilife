class AddFieldsToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :nui_id, :integer
    add_column :posts, :image_id, :string
    add_column :posts, :post, :text
    add_column :posts, :status, :integer
  end
end

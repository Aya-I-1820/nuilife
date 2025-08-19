class CreateNuis < ActiveRecord::Migration[7.1]
  def change
    create_table :nuis do |t|
      t.string :name
      t.text :profile
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

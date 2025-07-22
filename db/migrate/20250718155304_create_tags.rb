class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.string :tag_name, null: false # タグの重複を避ける
      t.timestamps
    end
    add_index :tags, :tag_name, unique: true # 検索を簡単にする
  end
end
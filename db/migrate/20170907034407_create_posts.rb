class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true, index: true
      t.string :title, limit: 255
      t.references :postable, polymorphic: true, index: true
      t.integer :status, default: 0, index: true
      t.text :body

      t.timestamps
    end
    add_index :posts, [:postable, :status]
    add_index :posts, [:user, :status]
  end
end

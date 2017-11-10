class CreatePostRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :post_ratings do |t|
      t.references :post, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :kind, null: false, default: 0
      t.integer :value, null: false, default: 0

      t.timestamps
    end
  end
end

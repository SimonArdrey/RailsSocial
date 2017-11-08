class AddRepliesAndTypeToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :kind, :integer, null: false, default: 0
    add_reference :posts, :parent, null: true, default: nil
  end
end

class AddRepliesAndTypeToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :kind, :string, null: false, default: "basic"
    add_reference :posts, :parent, null: true, default: nil
  end
end

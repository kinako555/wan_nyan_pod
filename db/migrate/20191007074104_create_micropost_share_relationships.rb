class CreateMicropostShareRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :micropost_share_relationships do |t|
      t.string :user_id
      t.string :micropost_id

      t.timestamps
    end
    add_index :micropost_share_relationships, :user_id
    add_index :micropost_share_relationships, :micropost_id
    add_index :micropost_share_relationships, [:user_id, :micropost_id], unique: true
  end
end

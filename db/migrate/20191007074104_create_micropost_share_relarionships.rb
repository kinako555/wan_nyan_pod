class CreateMicropostShareRelarionships < ActiveRecord::Migration[5.2]
  def change
    create_table :micropost_share_relarionships do |t|
      t.string :user_id
      t.string :micropost_id

      t.timestamps
    end
    add_index :micropost_share_relarionships, :user_id
    add_index :micropost_share_relarionships, :micropost_id
    add_index :micropost_share_relarionships, [:user_id, :micropost_id], unique: true
  end
end

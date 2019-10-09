class CreateMicropostFavoriteRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :micropost_favorite_relationships do |t|
      t.string :user_id
      t.string :micropost_id

      t.timestamps
    end
    add_index :micropost_favorite_relationships, :user_id
    add_index :micropost_favorite_relationships, :micropost_id
    add_index :micropost_favorite_relationships, [:user_id, :micropost_id], unique: true, name: 'index_mp_fav_relationships_on_user_id_and_micropost_id'
  end
end

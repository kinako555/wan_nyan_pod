class CreateMicropostsFunctionRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :microposts_function_relationships do |t|
      t.string  :function_type
      t.integer :checker_id
      t.integer :checked_id

      t.timestamps
    end
    add_index :microposts_function_relationships, :checker_id, :function_type
    add_index :microposts_function_relationships, :checked_id
    #TODO: :function_typeを加えるか検討
    add_index :microposts_function_relationships, [:checker_id, :checked_id]
  end
end

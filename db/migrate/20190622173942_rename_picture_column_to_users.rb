class RenamePictureColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :picture, :icon
  end
end

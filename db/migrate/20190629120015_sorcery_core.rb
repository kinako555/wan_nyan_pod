class SorceryCore < ActiveRecord::Migration[5.2]
  def change
      add_column :users, :crypted_password, :string
      add_column :users, :salt,             :string
  end
end

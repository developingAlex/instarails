class CreateJoinTableLikes < ActiveRecord::Migration[5.1]
  def change
    create_join_table :users, :photos, table_name: :likes do |t| 
      t.index [:user_id, :photo_id], unique: true
      t.index [:photo_id, :user_id], unique: true

      t.timestamp :created_at
    end
  end
end

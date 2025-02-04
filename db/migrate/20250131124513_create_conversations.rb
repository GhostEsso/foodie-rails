class CreateConversations < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations do |t|
      t.references :sender, foreign_key: { to_table: :users }
      t.references :receiver, foreign_key: { to_table: :users }
      t.references :dish, foreign_key: true

      t.timestamps
    end

    add_index :conversations, [ :sender_id, :receiver_id, :dish_id ], unique: true
  end
end

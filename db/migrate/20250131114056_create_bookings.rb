class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :dish, null: false, foreign_key: true
      t.integer :portions
      t.string :status

      t.timestamps
    end
  end
end

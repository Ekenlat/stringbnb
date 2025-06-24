class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.date :starting_date
      t.date :ending_date
      t.references :user, null: false, foreign_key: true
      t.references :instrument, null: false, foreign_key: true
      t.integer :total_price
      t.string :status

      t.timestamps
    end
  end
end

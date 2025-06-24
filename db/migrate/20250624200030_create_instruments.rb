class CreateInstruments < ActiveRecord::Migration[7.1]
  def change
    create_table :instruments do |t|
      t.string :instrument_type
      t.integer :price_per_day
      t.string :size
      t.references :user, null: false, foreign_key: true
      t.text :description
      t.string :status
      t.string :name

      t.timestamps
    end
  end
end

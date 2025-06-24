class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email_address
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :phone_number
      t.string :password

      t.timestamps
    end
  end
end

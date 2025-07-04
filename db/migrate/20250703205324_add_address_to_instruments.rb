class AddAddressToInstruments < ActiveRecord::Migration[7.1]
  def change
    add_column :instruments, :address, :string
  end
end

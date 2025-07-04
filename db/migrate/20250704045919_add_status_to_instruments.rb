class AddStatusToInstruments < ActiveRecord::Migration[7.1]
  def change
    add_column :instruments, :status, :string, default: "available"
  end
end

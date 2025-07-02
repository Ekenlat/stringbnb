class RemoveStatusFromInstruments < ActiveRecord::Migration[7.1]
  def change
    remove_column :instruments, :status, :string
  end
end

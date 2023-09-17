class AddFieldsToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :date, :date
    add_reference :transactions, :account, null: false, foreign_key: true
    add_column :transactions, :amount, :decimal
  end
end

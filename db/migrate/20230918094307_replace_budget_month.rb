class ReplaceBudgetMonth < ActiveRecord::Migration[7.0]
  def change
    remove_column :budgets, :month

    add_column :budgets, :year, :integer
    add_column :budgets, :month, :integer
  end
end

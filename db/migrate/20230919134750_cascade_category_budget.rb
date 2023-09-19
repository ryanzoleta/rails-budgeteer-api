class CascadeCategoryBudget < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :budgets, :categories
    add_foreign_key :budgets, :categories, on_delete: :cascade
  end
end

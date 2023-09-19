class CascadeCategoryTransaction < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :transactions, :categories
    add_foreign_key :transactions, :categories, on_delete: :cascade
  end
end

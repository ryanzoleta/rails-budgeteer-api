class CreateBudgets < ActiveRecord::Migration[7.0]
  def change
    create_table :budgets do |t|
      t.date :month
      t.references :category, null: false, foreign_key: true
      t.decimal :budgeted_amount

      t.timestamps
    end
  end
end

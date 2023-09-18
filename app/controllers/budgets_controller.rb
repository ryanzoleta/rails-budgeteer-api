class BudgetsController < ApplicationController
  def index
    @budgets = if params[:year]
                 Budget.where(year: params[:year]).all
               else
                 Budget.all
               end

    if params[:year]
      @categories = Category.all

      all_new_budgets = []

      (1..12).each do |m|
        month_budget = @budgets.find { |b| b[:month] == m }
        next if month_budget

        new_budgets = @categories.map do |category|
          { category_id: category.id, month: m, year: params[:year], budgeted_amount: 0 }
        end

        all_new_budgets.concat new_budgets
      end

      unless all_new_budgets.empty?
        Budget.insert_all(all_new_budgets)
        @budgets = Budget.where(year: params[:year]).all
      end
    end

    render json: @budgets
  end

  def create
    @budget = Budget.new({ category_id: params[:category_id], month: params[:month], year: params[:year],
                           budgeted_amount: params[:budgeted_amount] })

    if @budget.save
      render json: @budget
    else
      render json: { errors: @budget.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @budget = Budget.find(params[:id])

    render json: @budget
  end

  def update
    @budget = Budget.find(params[:id])

    @budget.month = params[:month] || @budget.month
    @budget.budgeted_amount = params[:budgeted_amount] || @budget.budgeted_amount

    if @budget.save
      render json: @budget
    else
      render json: { errors: @budget.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @budget = Budget.find(params[:id])

    @budget.destroy
    render json: 'record deleted', status: 200
  end
end

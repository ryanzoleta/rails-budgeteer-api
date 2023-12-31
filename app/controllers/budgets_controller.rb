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
        month_budget = @budgets.select { |b| b[:month] == m }

        if month_budget
          @categories.each do |category|
            category_budget = month_budget.find { |b| b[:category_id] == category.id }

            unless category_budget
              all_new_budgets.push({ category_id: category.id, month: m, year: params[:year], budgeted_amount: 0 })
            end
          end
        else
          new_budgets = @categories.map do |category|
            { category_id: category.id, month: m, year: params[:year], budgeted_amount: 0 }
          end

          all_new_budgets.concat new_budgets
        end
      end

      unless all_new_budgets.empty?
        Budget.insert_all(all_new_budgets)
        @budgets = Budget.where(year: params[:year]).all
      end
    end

    @budgets_json = @budgets.as_json

    @sums = Transaction.select('EXTRACT(YEAR FROM date) AS year, EXTRACT(MONTH FROM date) AS month, category_id, SUM(amount) AS total_amount')
                       .group('year, month, category_id')

    @sums.each do |s|
      puts s[:category_id]
    end

    @budgets_json.each do |b|
      sum = @sums.find do |s|
        s[:year] == b['year'] and s[:month] == b['month'] and s[:category_id] == b['category_id']
      end

      b[:sum] = sum ? sum[:total_amount] : 0
    end

    render json: @budgets_json
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

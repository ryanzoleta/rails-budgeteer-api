class BudgetsController < ApplicationController
  def index
    @budgets = if params[:year]
                 Budget.where('EXTRACT(YEAR FROM month) = ?', params[:year]).all
               else
                 Budget.all
               end
    render json: @budgets
  end

  def create
    @budget = Budget.new({ category_id: params[:category_id], month: params[:month],
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

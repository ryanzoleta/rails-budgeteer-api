class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.includes(account: :account_type).all
    render json: @transactions.to_json(include: { account: { include: :account_type } })
  end

  def create
    @transaction = Transaction.new({ account_id: params[:account_id], amount: params[:amount], date: params[:date] })

    if @transaction.save
      render json: @transaction
    else
      render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @transaction = Transaction.includes(account: :account_type).find(params[:id])

    render json: @transaction.to_json(include: { account: { include: :account_type } })
  end

  def update
    @transaction = Transaction.find(params[:id])

    @transaction.account_id = params[:account_id] || @transaction.account_id
    @transaction.amount = params[:amount] || @transaction.amount
    @transaction.date = params[:date] || @transaction.date

    if @transaction.save
      render json: @transaction
    else
      render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction = Transaction.find(params[:id])

    @transaction.destroy
    render json: 'record deleted', status: 200
  end
end

class AccountsController < ApplicationController
  def index
    @accounts = Account.includes(:account_type).all
    @accounts_json = @accounts.as_json(include: :account_type)

    @balances = Transaction.group('account_id').sum(:amount)

    @accounts_json.each do |a|
      balance = @balances[a['id']]

      a['balance'] = balance || 0
    end

    render json: @accounts_json
  end

  def create
    @account = Account.new({ name: params[:name], account_type_id: params[:account_type_id] })

    if @account.save
      render json: @account
    else
      render json: { errors: @account.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @account = Account.find(params[:id])

    render json: @account
  end

  def update
    @account = Account.find(params[:id])

    @account.name = params[:name] || @account.name
    @account.account_type_id = params[:account_type_id] || @account.account_type_id

    if @account.save
      render json: @account
    else
      render json: { errors: @account.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @account = Account.find(params[:id])

    @account.destroy
    render json: 'record deleted', status: 200
  end
end

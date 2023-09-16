class AccountsController < ApplicationController
  def index
    @accounts = Account.all
    render json: @accounts
  end

  def create
    @account = Account.new({ name: params[:name], account_type_id: params[:account_type_id] })

    if @account.save
      render json: @account
    else
      render json: { errors: @account.errors.full_messages }, status: :unprocessable_entity
    end
  end
end

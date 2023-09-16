class AccountTypesController < ApplicationController
  def index
    @account_types = AccountType.all
    render json: @account_types
  end

  def create
    @account_type = AccountType.new({ name: params[:name] })

    if @account_type.save
      render json: @account_type
    else
      render json: { errors: @account_type.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @account_type = AccountType.find(params[:id])

    render json: @account_type
  end

  def update
    @account_type = AccountType.find(params[:id])

    @account_type.name = params[:name]

    if @account_type.save
      render json: @account_type
    else
      render json: { errors: @account_type.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @account_type = AccountType.find(params[:id])

    @account_type.destroy
    render json: 'record deleted', status: 200
  end
end

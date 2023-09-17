class CategoriesController < ApplicationController
  def index
    @categories = Category.all
    render json: @categories
  end

  def create
    @category = Category.new({ name: params[:name] })

    if @category.save
      render json: @category
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @category = Category.find(params[:id])

    render json: @category
  end

  def update
    @category = Category.find(params[:id])

    @category.name = params[:name]

    if @category.save
      render json: @category
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find(params[:id])

    @category.destroy
    render json: 'record deleted', status: 200
  end
end

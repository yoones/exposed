class CategoriesController < ApplicationController
  expose :categories
  expose :category

  def index
  end

  def show
  end

  def new
  end

  def create
    if category.save
      redirect_to category, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if category.update(category_params)
      redirect_to category, notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    category.destroy
    redirect_to categories_url, notice: 'Category was successfully destroyed.'
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end

class Admin::CategoriesController < AdminController
  # POST /categories
  def create
    @new_category = Category.new(category_params)
    authorize @new_category

    if @new_category.save
      @category = Category.new
      @categoryies = Category.all
      redirect_to admin_categories_path, notice: "Category created!"
    else
      render :new
    end
  end

  # DELETE /admin/categories/1
  def destroy
    load_category
    @category.destroy
    redirect_to admin_categories_path, notice: "Category deleted!"
  end

  # GET /categories/1/edit
  def edit
    load_category
    @body_class = 'toolkit category'
    @header_navigation = true
  end

  # GET /categories
  def index
    @categories = Category.all
    authorize @categories
  end

  # GET /categories/1
  def show
    load_category
  end

  # PATCH /admin/categories/1
  def update
    load_category

    if @category.update_attributes(category_params)
      redirect_to edit_admin_category_path(@category), notice: "Category updated!"
    else
      render :edit, alert: "Cannot update category!"
    end
  end

  private

  def category_params
    params.require(:category).permit(:title, :description, :status)
  end

  def load_category
    @category = Category.find(params[:id])
    authorize @category
  end
end
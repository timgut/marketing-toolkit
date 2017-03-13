class Admin::CategoriesController < AdminController
  # POST /users
  def create
    @new_category = Category.new(category_params)
    if @new_category.save
      @category = Category.new
      @categoryies = Category.all
      redirect_to admin_categories_path, notice: "Category created!"
    else
      render :new
    end
  end

  # DELETE /users
  def destroy
    @category = Category.find(params[:id])
  end

  # GET /users/1/edit
  def edit
    @category = Category.find(params[:id])
    @body_class = 'toolkit category'
    @header_navigation = true
  end

  # GET /users
  def index
    @categories = Category.all
  end

  # GET /users/new
  def new
    @category = Category.new
  end

  # GET /users/1
  def show
    @category = Category.find(params[:id])
  end

  # PATCH /admin/categorys/1
  def update
    @category = Category.find(params[:id])

    if @category.update_attributes(category_params)
      redirect_to edit_admin_category_path(@category), notice: "Category updated!"
    else
      render :edit, alert: "Cannot update category!"
    end
  end

  # DELETE /adminc/ampaigns/1
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to admin_categories_path, notice: "Category deleted!"
  end

  private

  def category_params
    params.require(:category).permit(:title, :description, :status)
  end
end
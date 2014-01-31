class Admin::CategoriesController < ApplicationController
  
  before_filter :ensure_is_admin
  
  skip_filter :dashboard_only

  def index
    @selected_left_navi_link = "listing_categories"
    @categories = @current_community.top_level_categories.includes(:children)
  end
  
  def new
    @selected_left_navi_link = "listing_categories"
    @category = Category.new
    @default_transaction_types = @current_community.categories.last.transaction_types
  end

  def create
    @selected_left_navi_link = "listing_categories"
    @category = Category.new(params[:category])
    @category.community = @current_community
    @category.parent_id = nil if params[:category][:parent_id].blank?
    logger.info "Translations #{@category.translations.inspect}"
    if @category.save
      redirect_to admin_categories_path
    else
      flash[:error] = "Category saving failed"
      render :action => :new
    end
  end

  def edit
    @selected_left_navi_link = "listing_categories"
    @category = Category.find(params[:id])
    @default_transaction_types = @category.transaction_types
  end

  def update
    @selected_left_navi_link = "listing_categories"
    @category = Category.find(params[:id])
    @default_transaction_types = @category.transaction_types
    if @category.update_attributes(params[:category])
      redirect_to admin_categories_path
    else
      flash[:error] = "Category saving failed"
      render :action => :edit
    end
  end

  # Remove form
  def remove
    @selected_left_navi_link = "listing_categories"
    @category = Category.find(params[:id])
  end

  # Remove action
  def destroy
    @custom_field = CustomField.find(params[:id])

    success = if custom_field_belongs_to_community?(@custom_field, @current_community)
      @custom_field.destroy
    end

    flash[:error] = "Field doesn't belong to current community" unless success
    redirect_to admin_custom_fields_path
  end

end
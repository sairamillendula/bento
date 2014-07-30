class Admin::CollectionsController < Admin::BaseController
  before_action :set_collection, only: [:edit, :update, :destroy, :add_products, :remove_products, :sort_products]
  set_tab :collections
  cache_sweeper :collection_sweeper

  def index
    @collections = Collection.order('created_at DESC')
  end

  def show
    @collection = Collection.includes(:products).friendly.find(params[:id])
    if @collection.products.any?
      @products = Product.exclude_products(@collection.products.pluck(:product_id)).order('name')
    else
      @products = Product.order('name')
    end
  end

  def new
    @collection = Collection.new
  end

  def edit
  end

  def create
    @collection = Collection.new(safe_params)

    respond_to do |format|
      if @collection.save
        format.html { redirect_to admin_collection_url(@collection), notice: 'Collection was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @collection.update_attributes(safe_params)
        format.html { redirect_to admin_collection_url(@collection), notice: 'Collection was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @collection.destroy

    respond_to do |format|
      format.html { redirect_to admin_collections_url, notice: 'Collection was successfully deleted.' }
    end
  end

  def sort_products
    params[:product].each_with_index do |id, index|
      CollectionProduct.where(product_id: id, collection_id: @collection.id).update_all(position: index+1)
    end
    render nothing: true
  end

  def add_products
    @collection.products << Product.find(params[:product_id])
    @products = Product.exclude_products(@collection.products.pluck(:product_id)).order('name')

    respond_to do |format|
      format.js
    end
  end

  def remove_products
    @collection.products.delete(Product.find(params[:product_id]))

    if @collection.products.any?
      @products = Product.exclude_products(@collection.products.pluck(:product_id)).order('name')
    else
      @products = Product.order('name')
    end

    respond_to do |format|
      format.js
    end
  end

  private

    def set_collection
      @collection = Collection.friendly.find(params[:id])
    end

    def safe_params
      params.require(:collection).permit(:description, :name, :visible, :slug, :seo_title, :seo_description)
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

    def sort_column
      Collection.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

end

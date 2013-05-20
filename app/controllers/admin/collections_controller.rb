class Admin::CollectionsController < Admin::BaseController
  set_tab :collections
  cache_sweeper :collection_sweeper

  def index
    @collections = Collection.order('created_at DESC')
  end

  def show
    @collection = Collection.includes(:products).find(params[:id])
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
    @collection = Collection.find(params[:id])
  end

  def create
    @collection = Collection.new(params[:collection])

    respond_to do |format|
      if @collection.save
        format.html { redirect_to admin_collection_url(@collection), notice: 'Collection was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @collection = Collection.find(params[:id])

    respond_to do |format|
      if @collection.update_attributes(params[:collection])
        format.html { redirect_to admin_collection_url(@collection), notice: 'Collection was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @collection = Collection.find(params[:id])
    @collection.destroy

    respond_to do |format|
      format.html { redirect_to admin_collections_url, notice: 'Collection was successfully deleted.' }
    end
  end

  def sort_products
    params[:product].each_with_index do |id, index|
      CollectionProduct.update_all({position: index+1}, {product_id: id})
    end
    render nothing: true
  end

  def add_products
    @collection = Collection.find(params[:id])
    @collection.products << Product.find(params[:product_id])
    @products = Product.exclude_products(@collection.products.pluck(:product_id)).order('name')

    respond_to do |format|
      format.js
    end
  end

  def remove_products
    @collection = Collection.find(params[:id])
    @relationship = CollectionProduct.find_by_collection_id_and_product_id(@collection.id, params[:product_id])
    @relationship.destroy

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

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def sort_column
    Collection.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

end
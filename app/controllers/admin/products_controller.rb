class Admin::ProductsController < Admin::BaseController
  set_tab :products

  def index
    @products = Product.order('name')
  end

  def show
    @product = Product.includes(:stocks, variants: [:stocks]).find(params[:id])
  end

  def new
    @product = Product.new
    @product.auto_generate_variants = '1'
    @product.options.build unless @product.options.any?
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to admin_product_url(@product), notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to admin_product_url(@product), notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.can_be_deleted?
      @product.destroy

      respond_to do |format|
        format.html { redirect_to admin_products_url, notice: 'Product was successfully deleted.' }
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_product_url(@product), alert: 'Product cannot be deleted because of existing orders associated.' }
      end
    end
  end

  def feature
    Product.update_all({featured: true}, {id: params[:product_ids]})
    redirect_to admin_products_url
  end

end
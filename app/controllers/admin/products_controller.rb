class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [:update, :destroy]
  set_tab :products

  def index
    @products = Product.includes(:variants, :master).order(sort_column + " " + sort_direction).page(params[:page]).per(15)
  end

  def show
    @product = Product.friendly.includes(:stocks, variants: [:stocks]).find(params[:id])
  end

  def new
    @product = Product.new
    @product.has_options = false
    @product.auto_generate_variants = true
    @product.options.build unless @product.options.any?
  end

  def edit
    @product = Product.friendly.find(params[:id])
  end

  def create
    @product = Product.new(safe_params)

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
    respond_to do |format|
      if @product.update_attributes(safe_params)
        format.html { redirect_to admin_product_url(@product), notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @product.can_be_deleted?
      @product.destroy

      respond_to do |format|
        format.html { redirect_to admin_products_url, notice: 'Product was successfully deleted.' }
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_product_url(@product), alert: "#{t 'products.cannot_be_deleted'}." }
      end
    end
  end

  def feature
    Product.where(id: params[:product_ids]).update_all(featured: true)
    redirect_to admin_products_url
  end

  private

    def set_product
      @product = Product.friendly.find(params[:id])
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

    def sort_column
      Product.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

    def safe_params
      params.require(:product).permit(
        :name, :description, :visible, :sku, :slug, :featured, :supplier_id, :active,
        :category_tokens, :supplier_tokens, :pictures_attributes, :cross_sell_tokens, :has_options,
        :meta_tag, :seo_title, :seo_description, :auto_generate_variants,
        master_attributes: [:options, :price, :in_stock, :active, :sku, :reduced_price, :id],
        variants_attributes: [:option1, :option2, :option3, :price, :in_stock, :active, :selected, :reduced_price, :sku, "_destroy"],
        options_attributes: [:name, :values, "_destroy"]
      )
    end

end

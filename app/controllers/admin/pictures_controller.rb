class Admin::PicturesController < Admin::BaseController
  before_filter :load_product

  def index
    @pictures = @product.pictures

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pictures.map{|picture| picture.to_jq_upload } }
    end
  end

  def show
    @picture = Picture.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @picture }
    end
  end

  def create
    p_attr = params[:picture]
    p_attr[:upload] = params[:picture][:upload].first if params[:picture][:upload].class == Array

    @picture = @product.pictures.build(p_attr)

    respond_to do |format|
      if @picture.save
        format.html {
          render :json => [@picture.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json { render json: {files: [@picture.to_jq_upload]}, status: :created, location: [:admin, @product, @picture] }
      else
        format.html { render action: "new" }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy

    respond_to do |format|
      format.html { redirect_to [:admin, @product] }
      format.json { head :no_content }
    end
  end

  private

  def load_product
    @product = Product.find(params[:product_id])
  end
end
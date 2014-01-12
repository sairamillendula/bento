class Admin::PicturesController < Admin::BaseController
  before_action :load_product
  before_action :set_picture, only: [:show, :edit, :update, :destroy]

  def index
    @pictures = @product.pictures

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pictures.map{|picture| picture.to_jq_upload } }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @picture }
    end
  end

  def create
    p_attr = safe_params
    p_attr[:upload] = params[:picture][:upload].first if params[:picture][:upload].class == Array

    @picture = @product.pictures.build(p_attr)

    respond_to do |format|
      if @picture.save
        format.html {
          render json: [@picture.to_jq_upload].to_json,
          content_type: 'text/html',
          layout: false
        }
        format.json { render json: {files: [@picture.to_jq_upload]}, status: :created, location: [:admin, @product, @picture] }
      else
        format.html { render action: "new" }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    render layout: false
  end

  def update
    @picture.update_attributes(safe_params)
  end

  def destroy
    @picture.destroy

    respond_to do |format|
      format.html { redirect_to [:admin, @product] }
      format.json { head :no_content }
    end
  end

  def sort
    params[:picture].each_with_index do |id, index|
      Picture.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end

  private

    def load_product
      @product = Product.friendly.find(params[:product_id])
    end

    def set_picture
      @picture = Picture.find(params[:id])
    end

    def safe_params
      params.require(:picture).permit(:upload, :name)
    end

end
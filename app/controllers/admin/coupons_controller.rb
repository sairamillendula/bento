class Admin::CouponsController < Admin::BaseController
  before_action :set_coupon, only: [:edit, :update, :destroy]
  set_tab :coupons
  respond_to :html, :json

  def index
    @coupons = Coupon.all
  end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = Coupon.new(safe_params)

    respond_to do |format|
      if @coupon.save
        format.html { redirect_to admin_coupons_url, notice: 'Coupon was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @coupon.update_attributes(safe_params)
        format.html { redirect_to admin_coupons_url, notice: 'Coupon was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @coupon.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  	if @coupon.can_be_deleted?
  		respond_to do |format|
  		  @coupon.destroy
  		  format.html { redirect_to admin_coupons_url, notice: 'Coupon was successfully deleted.' }
  		end
  	else
  		respond_to do |format|
  		  format.html { redirect_to admin_coupons_url, alert: 'Coupon can not be deleted because of existing orders associated.' }
  	  end
  	end
  end

  private

    def set_coupon
      @coupon = Coupon.find(params[:id])
    end

    def safe_params
      params.require(:coupon).permit(:active, :code, :percentage, :amount)
    end

end
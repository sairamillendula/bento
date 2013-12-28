class ContactsController < ApplicationController
  
  def show
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(safe_params)
    if @contact.valid?
      AdminMailer.contact_us(@contact).deliver
      flash[:notice] = "#{t 'theme.contact.success_notice'}."
      redirect_to root_url
    else
      render action: 'show'
    end
  end

  private

    def safe_params
      params.require(:contact).permit(:name, :email, :content)
    end

end
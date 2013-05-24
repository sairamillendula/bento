class ContactsController < ApplicationController
  
  def show
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    if @contact.valid?
      AdminMailer.contact_us(@contact).deliver
      flash[:notice] = "Message sent! Thank you for contacting us."
      redirect_to root_url
    else
      render :action => 'show'
    end
  end

end
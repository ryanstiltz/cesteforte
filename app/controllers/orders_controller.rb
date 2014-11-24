class OrdersController < ApplicationController
	def destroy
  		current_order.destroy
  		session[:order_id] = nil
  		redirect_to :back
  	end

  def checkout
    @order = Shoppe::Order.find(current_order.id)
    if request.patch?
      if @order.proceed_to_confirm(params[:order].permit(:first_name, :last_name, :billing_address1, :billing_address2, :billing_address3, :billing_address4, :billing_country_id, :billing_postcode, :email_address, :phone_number))
        current_order.confirm!
        values = {
              business: "merchant@cesteforte.com",
              cmd: "_xclick",
              upload: 1,
              return: "#{Rails.application.secrets.app_host}#{checkout_confirmation_path}",
              invoice: current_order.id,
              item_name: "Ceste Forte Order",
              amount: @order.total.round(2),
              notify_url: "#{Rails.application.secrets.app_host}/hook",
              quantity: '1'
          }
         url="#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query
         redirect_to url
      end
    end
  end

  def confirmation
  end

   protect_from_forgery except: [:hook]
   def hook
    params.permit! # Permit all Paypal input params
    status = params[:payment_status]
    if status == "Completed"
      @order = Shoppe::Order.find(params[:invoice]) 
      payment = @order.payments.build(amount: @order.total,method: "paypal",reference: @order.number)
      payment.save
    end
    render nothing: true
  end

end

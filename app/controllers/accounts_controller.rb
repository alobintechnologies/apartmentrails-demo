class AccountsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
   def new
     gon.client_token = generate_client_token
     @account = Account.new
     @account.build_owner
   end

   def create
     @account = Account.new(account_params)
     if @account.valid?
       @result = Braintree::Transaction.sale(
                      amount: 30,
                      payment_method_nonce: params[:payment_method_nonce]
                   )
       if @result.success?
         Apartment::Tenant.create(@account.subdomain)
         Apartment::Tenant.switch!(@account.subdomain) rescue Apartment::Tenant.reset
         self.create_braintree_customer
         @account.save
         redirect_to new_user_session_url(subdomain: @account.subdomain)
       else
         render action: :new
       end
     else
       render action: :new
     end
   end

   private
     def account_params
       params.require(:account).permit(:subdomain, owner_attributes: [:name, :email, :password, :password_confirmation])
     end
     # generate client token for billing braintree
     def generate_client_token
       Braintree::ClientToken.generate
     end

     def create_braintree_customer
       if current_user.has_payment_info?
         result = Braintree::Customer.create(
            company: @account.name,
            email: @account.owner.email
         )
         @account.braintree_customer_id = result.customer.id
       else
         
       end
     end
end

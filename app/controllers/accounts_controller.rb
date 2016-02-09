class AccountsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
   def new
     gon.client_token = generate_client_token
     byebug
     @account = Account.new
     @account.build_owner
   end

   def create
     @account = Account.new(account_params)

     if @account.valid?
       Apartment::Tenant.create(@account.subdomain)
       Apartment::Tenant.switch!(@account.subdomain) rescue Apartment::Tenant.reset
       @account.save
       redirect_to new_user_session_url(subdomain: @account.subdomain)
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
end

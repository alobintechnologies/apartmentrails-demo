class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :verify_tenant, :authenticate_user!

  rescue_from Apartment::TenantNotFound do |exception|
    #ActionController::RoutingError.new('Not Found')
    # TODO: set the flash message here to show the user the tenant they accessing is not available
    redirect_to root_url(subdomain: false)
  end

  private
    def verify_tenant
      Apartment::Tenant.reset
      return unless request.subdomain.present?  # this line will help you from infinite loop issue
      account = Account.where(subdomain: request.subdomain).first
      if account
        Apartment::Tenant.switch!(account.subdomain)
      else
        raise Apartment::TenantNotFound
      end
    end
end

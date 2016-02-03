require 'apartment/elevators/subdomain'
require 'apartment/tenant'

module Apartment
  module Elevators
    class RescuedApartmentMiddleware < Apartment::Elevators::Subdomain
      def call(env)
        request = Rack::Request.new(env)
        # @processor is the current middleware instance and the call method will invoke the parse_tenant_name method.
        # if you need to change the subdomain database name you can change it by defining the parse_tenant_name method below
        database = @processor.call(request)

        begin
          Apartment::Tenant.switch!(database) if database
        rescue Apartment::TenantNotFound, ActiveRecord::NoDatabaseError
          Rails.logger.error "Error: Apartment says tenant was not found for #{database.inspect}"
          raise ActionController::RoutingError.new('Not Found')
          #return [404, {"Content-Type" => "text/html"}, ["Not Found"]]
        end

        @app.call(env)
      end
    end
  end
end

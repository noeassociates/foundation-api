module Foundation
  class Documentation < ::Sinatra::Base

    set :root, File.join(File.dirname(__FILE__), 'documentation')

    get '/api/docs' do
      @api = Foundation::API
      @routes = @api.routes
      @routes.select! {|r| r.route_prefix}
      erb :index
    end

    get '/api/demo' do
      @json = {
        first_name: "Joe",
        last_name: "Doe",
        email: "j.doe@pp.com",
        message: "Hi Joe! Thanks for stopping by today.",
        unit_ids: [1]
      }

      erb :demo
    end

    helpers do
      def param_type type
        type.to_s.match(/^\[(.*)\]$/) do |m|
          type = "Array of #{m[1]}s"
        end
        type
      end

      def formatted_path route
        route.route_path.gsub ':version', route.route_version
      end
    end

  end
end

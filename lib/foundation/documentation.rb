require 'sinatra'
require 'tilt/erb'
require 'foundation/api'

module Foundation
  class Documentation < ::Sinatra::Base

    set :root, File.join(File.dirname(__FILE__), 'documentation')

    get '/docs' do
      @api = Foundation::API
      @routes = @api.routes
      @routes.select!(&:version)
      erb :index
    end

    get '/demo' do
      @post = {
        first_name: "Joe",
        last_name: "Doe",
        email: "j.doe@pp.com",
        message: "Hi Joe! Thanks for stopping by today.",
        sales_agent: "Melissa",
        unit_ids: [1],
        data: {
          family: 'married',
          age: '40'
        }
      }

      @patch = {
        slug: 'joe-doe',
        data: {
          family: 'single'
        }
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
        route.path.gsub ':version', route.version
      end
    end

  end
end

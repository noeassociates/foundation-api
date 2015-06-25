require 'grape'
require 'rack/cors'
require 'email_regex'

require 'foundation/entities/unit'
require 'foundation/runner'
require 'foundation/interest_params'

module Foundation
  class API < Grape::API
    extend Foundation::InterestParams

    use Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: :get
      end
    end

    version 'v1', using: :path
    format :json
    prefix :api

    before do
      params.select! {|k, _| route.route_params.keys.include? k}
    end

    desc 'Returns unit names and ids in an array of JSON objects.',
         params: Foundation::Entities::Unit.documentation
    get 'units' do
      present Foundation.unit_class.all, with: Foundation::Entities::Unit
    end

    resource 'interest' do
      desc 'Records interest in a set of units. Returns a JSON object which includes the accepted_params on successful request.'
      interest_params!
      post do
        runner = Foundation::Runner.new Foundation.builders
        runner.before << Foundation::Builders::AcceptedParamsBuilder
        runner.after  << Foundation::Builders::SlugBuilder
        runner.after  << Foundation::Builders::UrlBuilder
        runner.run request, params
      end

      desc 'Update previously posted interest. Returns a JSON object which includes the accepted_params on successful request.'
      params do
        requires :slug, type: String
      end
      interest_params! required: false
      patch do
        runner = Foundation::Runner.new Foundation.updaters
        runner.before << Foundation::Builders::AcceptedParamsBuilder
        runner.run request, params
      end
    end
  end
end

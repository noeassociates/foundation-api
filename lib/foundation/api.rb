require 'grape'
require 'rack/cors'
require 'email_regex'

require 'foundation/entities/unit'
require 'foundation/runner'

module Foundation
  class API < Grape::API
    UNIT_IDS = -> { Foundation.unit_class.all.collect(&:id) }

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

    params do
      requires :first_name, type: String
      requires :last_name,  type: String
      requires :unit_ids,   type: Array[Integer],
                            values: UNIT_IDS,
                            desc: 'Must only include ids from units returned by the Unit endpoint.'
      optional :email,      type: String, regexp: EmailRegex::EMAIL_ADDRESS_REGEX,
                            desc: 'Must be a valid, non-blank email address.'
      optional :message,    type: String,
                            desc: 'A personal message to be displayed on the site or emailed to the recipient.'
      optional :data,       type: Hash
    end
    resource 'interest' do
      desc 'Records interest in a set of units. Returns a JSON object which includes the accepted_params on successful request.'
      post do
        runner = Foundation::Runner.new Foundation.builders
        runner.before << Foundation::Builders::AcceptedParamsBuilder
        runner.after  << Foundation::Builders::SlugBuilder
        runner.after  << Foundation::Builders::UrlBuilder
        runner.run request, params
      end
    end
  end
end

ENV['RACK_ENV'] = 'test'

require "minitest/autorun"
require "rack/test"
require "foundation-api"

class Foundation::DocumentationTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Foundation::Documentation
  end

  def test_get_index
    get "/docs"
    assert last_response.ok?
  end

end

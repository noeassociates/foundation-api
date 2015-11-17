ENV['RACK_ENV'] = 'test'

require "minitest/autorun"
require "minitest/mock"
require "rack"
require "rack/test"
require "foundation-api"

class DummyUnit
  attr_accessor :id, :name, :not_exposed_in_json

  def initialize attrs
    @id = attrs[:id]
    @name = attrs[:name]
    @not_exposed_in_json = 'foo'
  end

  def self.all
    [new(name: 'test', id: 1)]
  end
end

class Foundation::APITest < Minitest::Test
  include Rack::Test::Methods

  def setup
    @cached_builders      = Foundation.builders
    @cached_unit_class    = Foundation.unit_class
    Foundation.unit_class = DummyUnit
    Foundation.builders   = []
  end

  def teardown
    Foundation.builders   = @cached_builders
    Foundation.unit_class = @cached_unit_class
  end

  def app
    Foundation::API
  end

  def test_get_api_units_returns_an_array
    get "/v1/units"
    assert last_response.ok?
    assert_kind_of Array, JSON.parse(last_response.body)
  end

  def test_returns_unit_json
    get "/v1/units"
    assert_equal [{ "name" => "test", "id" => 1 }], JSON.parse(last_response.body)
  end

  def test_refuses_empty_post_to_interest_endpoint
    post "/v1/interest"
    refute last_response.created?
  end

  def test_accepts_reasonable_post_to_interest_endpoint
    post "/v1/interest", valid_post_params
    assert last_response.created?
  end

  def test_accepts_post_with_empty_unit_ids_to_interest_endpoint
    post "/v1/interest", valid_post_params.merge("unit_ids" => [])
    assert last_response.created?, -> { JSON.parse(last_response.body)['error'] }
  end

  def test_accepts_reasonable_patch_to_interest_endpoint
    post "/v1/interest", valid_patch_params
    assert last_response.created?
  end

  def test_returns_accepted_params_in_response
    post "/v1/interest", valid_post_params
    assert_equal valid_post_params, JSON.parse(last_response.body)["accepted_params"]
  end

  def test_returns_only_accepted_params_in_response
    post "/v1/interest", valid_post_params.merge("foo" => "bar")
    assert_equal valid_post_params, JSON.parse(last_response.body)["accepted_params"]
  end

  def test_returns_slug_in_repsonse
    post "/v1/interest", valid_post_params.merge("first_name" => "Bar Qaaz", "last_name" => "Foo")
    assert_equal 'bar-qaaz-foo', JSON.parse(last_response.body)["slug"]
  end

  def test_passes_request_and_params_to_configured_builders
    builder = Minitest::Mock.new
    builder.expect :new,   builder, [Grape::Request]
    builder.expect :build, builder, [Hashie::Mash, Hashie::Mash]

    Foundation.builders << builder

    post "/v1/interest", valid_post_params

    builder.verify
  end

  def test_runs_with_default_builder
    Foundation.builders << Foundation::Builder

    post "/v1/interest", valid_post_params
    assert last_response.created?
  end

  def test_refuses_post_with_invalid_ids
    invalid_post_params = valid_post_params.merge unit_ids: 9999
    post "/v1/interest", invalid_post_params
    refute last_response.created?
  end

  def test_refuses_post_with_invalid_email
    invalid_post_params = valid_post_params.merge email: 'fooooo.sd'
    post "/v1/interest", invalid_post_params
    refute last_response.created?
  end

  def test_refuses_patch_without_slug
    invalid_patch_params = valid_patch_params
    invalid_patch_params.delete 'slug'
    patch "/v1/interest", invalid_patch_params
    refute last_response.created?
  end

  protected

  def valid_post_params
    {
      "first_name" => 'foo',
      "last_name" => 'bar',
      "email" => 'foo@bar.com',
      "unit_ids" => [1]
    }
  end

  def valid_patch_params
    valid_post_params.merge "slug" => 'some_sluggy_slug'
  end
end

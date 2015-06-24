require "minitest/autorun"
require "minitest/mock"

require "foundation-api"

class Foundation::RunnerTest < Minitest::Test

  def test_runs_processors
    request = params = Hashie::Mash.new

    builder = Minitest::Mock.new
    builder.expect :new,   builder, [request]
    builder.expect :build, builder, [params, Hashie::Mash]

    runner = Foundation::Runner.new [builder]
    runner.run request, params

    builder.verify
  end

end

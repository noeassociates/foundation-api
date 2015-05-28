require "minitest/autorun"
require "foundation-api"

class FoundationTest < Minitest::Test

  def test_config
    Foundation.config do |f|
      assert_equal Foundation, f
    end
  end

end

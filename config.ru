lib = File.join(File.dirname(__FILE__), 'lib')
$:.unshift lib unless $:.include?(lib)

require 'rack/rewrite'

require 'foundation'
require 'foundation/documentation/demo_unit'

Foundation.config do |f|
  f.unit_class = Foundation::Documentation::DemoUnit
end

use Rack::Rewrite do
  r302 '/', '/api/docs'
end

run Rack::Cascade.new [
  Foundation::API,
  Foundation::Documentation
]

lib = File.join(File.dirname(__FILE__), 'lib')
$:.unshift lib unless $:.include?(lib)

require 'foundation'

run Rack::Cascade.new [
  Foundation::API,
  Foundation::Documentation
]

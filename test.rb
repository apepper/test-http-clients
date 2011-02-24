require 'rubygems'
require 'bundler'
Bundler.require :default
require 'uri'
require 'benchmark'
require 'yajl/json_gem'
require 'net/http'

ITERATIONS = 1000
TESTS = []

def test_http(name, &block)
  TESTS << [name, block]
end

URL = URI.parse("http://localhost/~vincentlandgraf/test.json")

dir = File.dirname(__FILE__)

Dir[File.join(dir, "test_*.rb")].each do |file|
  require file
end

at_exit do
  puts "Execute http performance test using ruby #{RUBY_DESCRIPTION}"
  puts "  doing #{ITERATIONS} request in each test..."
  Benchmark.bm(20) do |x|
    for name, block in TESTS do
      begin
        x.report("testing #{name}") do
          ITERATIONS.times(&block)
        end
      rescue => ex
        puts " --> failed #{ex}"
      end
    end
  end
end

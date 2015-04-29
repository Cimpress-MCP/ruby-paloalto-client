require "fakeweb"
require "simplecov"
require "nokogiri"

SimpleCov.start do
  add_filter "/spec"
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

# define the root of the spec files
unless defined?(SPEC_ROOT)
  SPEC_ROOT = File.join(File.dirname(__FILE__))
end

# define an easy way to load fixture files (clean up code a bit)
def fixture_file(*name)
  File.join(SPEC_ROOT, 'fixtures', name)
end

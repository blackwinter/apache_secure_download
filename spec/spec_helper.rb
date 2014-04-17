$:.unshift('lib') unless $:.first == 'lib'

require 'apache/secure_download'
require 'apache/mock_constants'

RSpec.configure do |config|
  %w[expect mock].each { |what|
    config.send("#{what}_with", :rspec) { |c| c.syntax = [:should, :expect] }
  }

  config.before :each do
    @now = Time.now
    Time.stub(:now) { @now }
  end
end

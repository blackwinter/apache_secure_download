$:.unshift('lib') unless $:.first == 'lib'

require 'apache/secure_download'
require 'apache/mock_constants'

RSpec.configure do |config|
  config.before :each do
    @now = Time.now
    Time.stub!(:now).and_return { @now }
  end
end

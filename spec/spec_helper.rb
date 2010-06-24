require 'spec'

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'apache/secure_download'
require 'apache/mock_constants'

Spec::Runner.configure do |config|
  config.before :each do
    @now = Time.now
    Time.stub!(:now).and_return { @now }
  end
end

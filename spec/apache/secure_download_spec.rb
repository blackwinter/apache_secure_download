describe Apache::SecureDownload do

  before :each do
    @class = Apache::SecureDownload
  end

  describe "#initialize" do

    it "should require a secret" do
      lambda { @class.new(nil) }.should raise_error(ArgumentError, 'secret is missing')
    end

    it "should accept a string for secret" do
      @class.new('secret').should be_an_instance_of(@class)
    end

    it "should require secret to be a string" do
      lambda { @class.new(42) }.should raise_error(ArgumentError, 'secret is missing')
    end

    it "should not require :deny" do
      @class.new('secret', :deny => nil).should be_an_instance_of(@class)
    end

    it "should accept a regexp for :deny" do
      @class.new('secret', :deny => /regexp/).should be_an_instance_of(@class)
    end

    it "should require :deny to be a regexp" do
      lambda { @class.new('secret', :deny => 'regexp') }.should raise_error(ArgumentError, ':deny is not a regexp')
    end

    it "should not require :allow" do
      @class.new('secret', :allow => nil).should be_an_instance_of(@class)
    end

    it "should accept a regexp for :allow" do
      @class.new('secret', :allow => /regexp/).should be_an_instance_of(@class)
    end

    it "should require :allow to be a regexp" do
      lambda { @class.new('secret', :allow => 'regexp') }.should raise_error(ArgumentError, ':allow is not a regexp')
    end

    it "should accept :deny and :allow at the same time" do
      @class.new('secret', :deny => /regexp/, :allow => /regexp/).should be_an_instance_of(@class)
    end

  end

  describe "#check_access" do

    def self.it_should_be_allowed(msg, &block)
      it "should be allowed #{msg}" do
        instance_eval(&block) if block

        mock_request
        @handler.check_access(@request).should == Apache::OK
      end
    end

    def self.it_should_be_forbidden(msg, &block)
      it "should be forbidden #{msg}" do
        instance_eval(&block) if block

        mock_request
        @handler.check_access(@request).should == Apache::FORBIDDEN
      end
    end

    before :each do
      @secret = 'secret'
      @uri = '/some/uri'

      @timestamp = Time.now.to_i + 23
      @token = @class::Util.token(@secret, @uri, @timestamp)

      @handler = @class.new(@secret)
    end

    shared_examples "normally" do

      it_should_be_allowed "with correct secret"

      it_should_be_forbidden "with incorrect secret" do
        @token = @class::Util.token(@secret.swapcase, @uri, @timestamp)
      end

      it_should_be_forbidden "for different URL" do
        @token = @class::Util.token(@secret, @uri + '2', @timestamp)
      end

      it_should_be_forbidden "with different timestamp" do
        @token = @class::Util.token(@secret, @uri, @timestamp + 42)
      end

      it_should_be_forbidden "when expired" do
        @now += 60
      end

    end

    shared_examples "always allowed" do

      it_should_be_allowed "with correct secret"

      it_should_be_allowed "with incorrect secret" do
        @token = @class::Util.token(@secret.swapcase, @uri, @timestamp)
      end

      it_should_be_allowed "for different URL" do
        @token = @class::Util.token(@secret, @uri + '2', @timestamp)
      end

      it_should_be_allowed "with different timestamp" do
        @token = @class::Util.token(@secret, @uri, @timestamp + 42)
      end

      it_should_be_allowed "when expired" do
        @now += 60
      end

    end

    shared_examples "always forbidden" do

      it_should_be_forbidden "with correct secret"

      it_should_be_forbidden "with incorrect secret" do
        @token = @class::Util.token(@secret.swapcase, @uri, @timestamp)
      end

      it_should_be_forbidden "for different URL" do
        @token = @class::Util.token(@secret, @uri + '2', @timestamp)
      end

      it_should_be_forbidden "with different timestamp" do
        @token = @class::Util.token(@secret, @uri, @timestamp + 42)
      end

      it_should_be_forbidden "when expired" do
        @now += 60
      end

    end

    it_should_behave_like "normally"

    describe "with query args" do

      before :each do
        @args = 'foo=bar'
        @token = @class::Util.token(@secret, "#{@uri}?#{@args}", @timestamp)
      end

      it_should_behave_like "normally"

    end

    describe "with matching :allow" do

      before :each do
        @handler = @class.new(@secret, :allow => /\A\/some\//)
      end

      it_should_behave_like "always allowed"

      describe "and matching :deny" do

        before :each do
          @handler.instance_variable_set(:@deny, /\A\/some\//)
        end

        it_should_behave_like "always forbidden"

      end

      describe "and non-matching :deny" do

        before :each do
          @handler.instance_variable_set(:@deny, /\A\/other\//)
        end

        it_should_behave_like "always allowed"

      end

    end

    describe "with non-matching :allow" do

      before :each do
        @handler = @class.new(@secret, :allow => /\A\/other\//)
      end

      it_should_behave_like "normally"

    end

    describe "with matching :deny" do

      before :each do
        @handler = @class.new(@secret, :deny => /\A\/some\//)
      end

      it_should_behave_like "always forbidden"

      describe "and matching :allow" do

        before :each do
          @handler.instance_variable_set(:@allow, /\A\/some\//)
        end

        it_should_behave_like "always forbidden"

      end

      describe "and non-matching :allow" do

        before :each do
          @handler.instance_variable_set(:@allow, /\A\/other\//)
        end

        it_should_behave_like "always forbidden"

      end

    end

    describe "with non-matching :deny" do

      before :each do
        @handler = @class.new(@secret, :deny => /\A\/other\//)
      end

      it_should_behave_like "normally"

    end

    def mock_request
      _asd = "#{'%010x' % @timestamp}#{@token}"

      args = "_asd=#{_asd}"
      args = "#{@args}&#{args}" if @args

      clean_args = @class::Util.real_query(args)

      @request = mock('Request', :uri => @uri, :unparsed_uri => "#{@uri}?#{args}")

      @request.should_receive(:param).with('_asd').any_number_of_times.and_return(_asd)

      @request.should_receive(:args).with(no_args).any_number_of_times.and_return(args)
      @request.should_receive(:args=).with(clean_args).any_number_of_times.and_return(clean_args)
    end

  end

end

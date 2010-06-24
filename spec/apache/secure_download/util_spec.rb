describe Apache::SecureDownload::Util do

  before :each do
    @module = Apache::SecureDownload::Util
    @secret = 'secret'
  end

  describe "#secure_url" do

    before :each do
      @url = '/secure/url'
      @now = Time.at(1204024618)
    end

    describe "generating secure URLs" do

      before :each do
        @timestamp = @now.to_i + 60
        @token     = '5671a9b3966e8bbed91fc0bb5594d576c504cdf0'

        @result = "?timestamp=#{@timestamp}&token=#{@token}"
      end

      it "should generate secure URL" do
        url = @url
        @module.secure_url(@secret, url).should == url + @result
      end

      it "should take path component into account" do
        url = @url + '2'
        @module.secure_url(@secret, url).should =~ /\A#{Regexp.escape(url)}\?/
        @module.secure_url(@secret, url).should_not == url + @result
      end

      it "should ignore host component" do
        url = 'http://example.com' + @url
        @module.secure_url(@secret, url).should == url + @result
      end

      it "should preserve query component" do
        url = @url + '?a=b&x=y'
        @module.secure_url(@secret, url).should =~ /\A#{Regexp.escape(url)}&/
      end

      it "should preserve URL fragment" do
        url = @url + '#foo'
        result = @module.secure_url(@secret, url)

        result.should =~ /\A#{Regexp.escape(@url)}\?/
        result.should =~ /#foo\z/
      end

      it "should preserve query component and URL fragment" do
        url = @url + '?x=y#foo'
        result = @module.secure_url(@secret, url)

        result.should =~ /\A#{Regexp.escape(@url)}\?x=y&/
        result.should =~ /#foo\z/
      end

      it "should respect secret" do
        @module.secure_url(@secret.swapcase, @url).should_not == @url + @result
      end

    end

    describe "with custom expiration" do

      before :each do
        @result1 = "#{@url}?timestamp=1204025218&token=7e51f91cf4406f308a8df24f4e2cbf188de3c1bf"
        @result2 = "#{@url}?timestamp=1204026000&token=58eb12f9fc3fcd984fe4e918d3fd0590392c172d"
      end

      it "should accept time" do
        @module.secure_url(@secret, @url, Time.now + 600).should == @result1
      end

      it "should accept offset" do
        @module.secure_url(@secret, @url, :offset => 600).should == @result2
        @result2.should_not == @result1
      end

      it "should disable caching with offset" do
        @module.secure_url(@secret, @url, :offset => 600, :cache => false).should == @result1
        @result1.should_not == @result2
      end

    end

    describe "caching" do

      before :each do
        @result1 = "#{@url}?timestamp=1204024680&token=ccf279daf1787d34ad063cbf5851ee88aae967fb"
        @result2 = "#{@url}?timestamp=1204024740&token=c7dcea5679ad539a7bad1dc4b7f44eb3dd36d6e8"
        @result3 = "#{@url}?timestamp=1204024800&token=aa11618f1cc0883a29e9239b777ca53dfc4d9604"
      end

      describe "explicitly (with expires)" do

        it "should produce identical URLs for a window of 1 minute (on average)" do
          t = Time.now

          @module.secure_url(@secret, @url, :expires => t,      :cache => 60).should == @result1
          @module.secure_url(@secret, @url, :expires => t + 30, :cache => 60).should == @result1
          @module.secure_url(@secret, @url, :expires => t + 60, :cache => 60).should == @result2
          @module.secure_url(@secret, @url, :expires => t + 90, :cache => 60).should == @result2
        end

      end

      describe "implicitly (with offset)" do

        it "should produce identical URLs for a window of 1 minute (on average)" do
          @module.secure_url(@secret, @url, :offset => 60).should == @result2
          @now += 30  # 30 seconds later...
          @module.secure_url(@secret, @url, :offset => 60).should == @result2
          @now += 30  # 30 seconds later...
          @module.secure_url(@secret, @url, :offset => 60).should == @result3
          @now += 30  # 30 seconds later...
          @module.secure_url(@secret, @url, :offset => 60).should == @result3
        end

      end

    end

  end

  describe "#token" do

    before :each do
      @path = '/some/path'
      @timestamp = Time.now.to_i

      @result = @module.token(@secret, @path, @timestamp)
    end

    it "should take secret into account" do
      @module.token(@secret.swapcase, @path, @timestamp).should_not == @result
    end

    it "should take path into account" do
      @module.token(@secret, @path + '/foo', @timestamp).should_not == @result
    end

    it "should take query parameters in path into account" do
      @module.token(@secret, @path + '?foo=bar', @timestamp).should_not == @result
    end

    it "should take timestamp into account" do
      @module.token(@secret, @path, @timestamp + 42).should_not == @result
    end

    it "should ignore timestamp parameter in path" do
      @module.token(@secret, @path + '?timestamp=foo', @timestamp).should == @result
    end

    it "should ignore token parameter in path" do
      @module.token(@secret, @path + '?token=bar', @timestamp).should == @result
    end

    it "should ignore timestamp and token parameters in path" do
      @module.token(@secret, @path + '?timestamp=foo&token=bar', @timestamp).should == @result
    end

    it "should ignore timestamp and token parameters in path, regardless of order" do
      @module.token(@secret, @path + '?token=bar&timestamp=foo', @timestamp).should == @result
    end

    describe "when other parameters are present in path" do

      describe "at the front" do

        before :each do
          @path2 = @path + '?foo=bar'
          @result2 = @module.token(@secret, @path2, @timestamp)
        end

        it "should not ignore them" do
          @module.token(@secret, @path2 + '&timestamp=foo&token=bar', @timestamp).should_not == @result
        end

        it "should ignore timestamp parameter in path" do
          @module.token(@secret, @path2 + '&timestamp=foo', @timestamp).should == @result2
        end

        it "should ignore token parameter in path" do
          @module.token(@secret, @path2 + '&token=bar', @timestamp).should == @result2
        end

        it "should ignore timestamp and token parameters in path" do
          @module.token(@secret, @path2 + '&timestamp=foo&token=bar', @timestamp).should == @result2
        end

        it "should ignore timestamp and token parameters in path, regardless of order" do
          @module.token(@secret, @path2 + '&token=bar&timestamp=foo', @timestamp).should == @result2
        end

      end

      describe "at the end" do

        before :each do
          @query = '&foo=bar'
          @result2 = @module.token(@secret, @path + @query.sub(/&/, '?'), @timestamp)
        end

        it "should not ignore them" do
          @module.token(@secret, @path + '?timestamp=foo&token=bar' + @query, @timestamp).should_not == @result
        end

        it "should ignore timestamp parameter in path" do
          @module.token(@secret, @path + '?timestamp=foo' + @query, @timestamp).should == @result2
        end

        it "should ignore token parameter in path" do
          @module.token(@secret, @path + '?token=bar' + @query, @timestamp).should == @result2
        end

        it "should ignore timestamp and token parameters in path" do
          @module.token(@secret, @path + '?timestamp=foo&token=bar' + @query, @timestamp).should == @result2
        end

        it "should ignore timestamp and token parameters in path, regardless of order" do
          @module.token(@secret, @path + '?token=bar&timestamp=foo' + @query, @timestamp).should == @result2
        end

      end

    end

  end

  describe "#real_path" do

    before :each do
      @path = '/some/path'
    end

    describe "without recognized query parameters" do

      it "should leave the path intact" do
        @module.real_path(@path).should == @path
      end

      it "should leave other query parameters intact" do
        @module.real_path(@path + '?foo=bar').should == @path + '?foo=bar'
      end

    end

    describe "with recognized query parameters" do

      it "should remove timestamp parameter" do
        @module.real_path(@path + '?timestamp=foo').should == @path
      end

      it "should remove token parameter" do
        @module.real_path(@path + '?token=bar').should == @path
      end

      it "should remove timestamp and token parameters" do
        @module.real_path(@path + '?timestamp=foo&token=bar').should == @path
      end

      it "should remove timestamp and token parameters, regardless of order" do
        @module.real_path(@path + '?token=bar&timestamp=foo').should == @path
      end

      describe "when other parameters are present" do

        describe "at the front" do

          before :each do
            @path2 = @path + '?foo=bar'
          end

          it "should remove timestamp parameter" do
            @module.real_path(@path2 + '&timestamp=foo').should == @path2
          end

          it "should remove token parameter" do
            @module.real_path(@path2 + '&token=bar').should == @path2
          end

          it "should remove timestamp and token parameters" do
            @module.real_path(@path2 + '&timestamp=foo&token=bar').should == @path2
          end

          it "should remove timestamp and token parameters, regardless of order" do
            @module.real_path(@path2 + '&token=bar&timestamp=foo').should == @path2
          end

        end

        describe "at the end" do

          before :each do
            @query = '&foo=bar'
            @path2 = @path + @query.sub(/&/, '?')
          end

          it "should remove timestamp parameter" do
            @module.real_path(@path + '?timestamp=foo' + @query).should == @path2
          end

          it "should remove token parameter" do
            @module.real_path(@path + '?token=bar' + @query).should == @path2
          end

          it "should remove timestamp and token parameters" do
            @module.real_path(@path + '?timestamp=foo&token=bar' + @query).should == @path2
          end

          it "should remove timestamp and token parameters, regardless of order" do
            @module.real_path(@path + '?token=bar&timestamp=foo' + @query).should == @path2
          end

        end

      end

    end

  end

  describe "#real_query" do

    before :each do
      @query = 'some=query'
    end

    describe "without recognized query parameters" do

      it "should leave the query intact" do
        @module.real_query(@query).should == @query
      end

      it "should leave other query parameters intact" do
        @module.real_query(@query + '&foo=bar').should == @query + '&foo=bar'
      end

    end

    describe "with recognized query parameters" do

      it "should remove timestamp parameter" do
        @module.real_query(@query + '&timestamp=foo').should == @query
      end

      it "should remove token parameter" do
        @module.real_query(@query + '&token=bar').should == @query
      end

      it "should remove timestamp and token parameters" do
        @module.real_query(@query + '&timestamp=foo&token=bar').should == @query
      end

      it "should remove timestamp and token parameters, regardless of order" do
        @module.real_query(@query + '&token=bar&timestamp=foo').should == @query
      end

      describe "when other parameters are present" do

        before :each do
          @params = '&foo=bar'
          @query2 = @query + @params
        end

        it "should remove timestamp parameter" do
          @module.real_query(@query + '&timestamp=foo' + @params).should == @query2
        end

        it "should remove token parameter" do
          @module.real_query(@query + '&token=bar' + @params).should == @query2
        end

        it "should remove timestamp and token parameters" do
          @module.real_query(@query + '&timestamp=foo&token=bar' + @params).should == @query2
        end

        it "should remove timestamp and token parameters, regardless of order" do
          @module.real_query(@query + '&token=bar&timestamp=foo' + @params).should == @query2
        end

      end

    end

  end

end

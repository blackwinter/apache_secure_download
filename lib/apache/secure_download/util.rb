#--
###############################################################################
#                                                                             #
# A component of apache_secure_download.                                      #
#                                                                             #
# Copyright (C) 2008-2011 University of Cologne,                              #
#                         Albertus-Magnus-Platz,                              #
#                         50923 Cologne, Germany                              #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@uni-koeln.de>                                    #
#                                                                             #
# apache_secure_download is free software: you can redistribute it and/or     #
# modify it under the terms of the GNU Affero General Public License as       #
# published by the Free Software Foundation, either version 3 of the          #
# License, or (at your option) any later version.                             #
#                                                                             #
# apache_secure_download is distributed in the hope that it will be           #
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty         #
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU         #
# Affero General Public License for more details.                             #
#                                                                             #
# You should have received a copy of the GNU Affero General Public            #
# License along with apache_secure_download. If not, see                      #
# <http://www.gnu.org/licenses/>.                                             #
#                                                                             #
###############################################################################
#++

require 'digest/sha1'
require 'uri'

module Apache

  class SecureDownload

    module Util

      extend self

      TOKEN_KEY = '_asd'

      TOKEN_LENGTH = Digest::SHA1.hexdigest('').length

      TIMESTAMP_LENGTH = 10  # sufficient 'til 36812 ;)

      # Creates a valid URL to the secured resource, identified by +url+. The
      # argument +secret+ is the shared secret string that has been passed to
      # the relevant RubyAccessHandler instance (cf. SecureDownload.new).
      #
      # The expiration time may be either given as a Time (or Integer), or as
      # a Hash with the following parameters:
      #
      # <tt>:expires</tt>:: Same as for the simple +expires+ argument
      # <tt>:offset</tt>::  The amount of seconds in the future (only if
      #                     <tt>:expires</tt> is not given)
      # <tt>:cache</tt>::   A time window for which identical URLs shall be
      #                     produced, on average (defaults to <tt>:offset</tt>,
      #                     if given)
      #
      # Examples (<tt>s = "secret"</tt>):
      #
      #   # Only the path component (and an optional query component) will be taken into account
      #   secure_url(s, "/secure/url")                    #=> "/secure/url?_asd=0047c3f5665671a9b3966e8bbed91fc0bb5594d576c504cdf0"
      #   secure_url(s, "http://example.com/secure/url")  #=> "http://example.com/secure/url?_asd=0047c3f5665671a9b3966e8bbed91fc0bb5594d576c504cdf0"
      #   secure_url(s, "/secure/url?query=value")        #=> "/secure/url?query=value&_asd=0047c3f566b482f943c35f4a1b5da6c646df6a65c0edc364cf"
      #
      #   # Expires in 10 minutes
      #   secure_url(s, "/secure/url", Time.now + 600)  #=> "/secure/url?_asd=0047c3f7827e51f91cf4406f308a8df24f4e2cbf188de3c1bf"
      #   secure_url(s, "/secure/url", :offset => 600)  #=> "/secure/url?_asd=0047c3fa9058eb12f9fc3fcd984fe4e918d3fd0590392c172d"
      #
      #   # Setting an offset will also allow caching; turn it off explicitly
      #   secure_url(s, "/secure/url", :offset => 600, :cache => false)  #=> "/secure/url?_asd=0047c3f7827e51f91cf4406f308a8df24f4e2cbf188de3c1bf"
      #
      #   # Produce identical URLs for a window of 1 minute (on average)
      #   t = Time.now
      #   secure_url(s, "/secure/url", :expires => t,      :cache => 60)  #=> "/secure/url?_asd=0047c3f568ccf279daf1787d34ad063cbf5851ee88aae967fb"
      #   secure_url(s, "/secure/url", :expires => t + 30, :cache => 60)  #=> "/secure/url?_asd=0047c3f568ccf279daf1787d34ad063cbf5851ee88aae967fb"
      #   secure_url(s, "/secure/url", :expires => t + 60, :cache => 60)  #=> "/secure/url?_asd=0047c3f5a4c7dcea5679ad539a7bad1dc4b7f44eb3dd36d6e8"
      #   secure_url(s, "/secure/url", :expires => t + 90, :cache => 60)  #=> "/secure/url?_asd=0047c3f5a4c7dcea5679ad539a7bad1dc4b7f44eb3dd36d6e8"
      #
      #   # Same as before, but use offset
      #   secure_url(s, "/secure/url", :offset => 60) #=> "/secure/url?_asd=0047c3f5a4c7dcea5679ad539a7bad1dc4b7f44eb3dd36d6e8"
      #   # 30 seconds later...
      #   secure_url(s, "/secure/url", :offset => 60) #=> "/secure/url?_asd=0047c3f5a4c7dcea5679ad539a7bad1dc4b7f44eb3dd36d6e8"
      #   # 30 seconds later...
      #   secure_url(s, "/secure/url", :offset => 60) #=> "/secure/url?_asd=0047c3f5e0aa11618f1cc0883a29e9239b777ca53dfc4d9604"
      #   # 30 seconds later...
      #   secure_url(s, "/secure/url", :offset => 60) #=> "/secure/url?_asd=0047c3f5e0aa11618f1cc0883a29e9239b777ca53dfc4d9604"
      def secure_url(s, u, e = Time.now + 60)
        if e.is_a?(Hash)
          e[:offset] ||= 60
          c = e[:cache] || e[:offset]

          t = (e[:expires] || Time.now + e[:offset]).to_i

          unless e[:cache] == false || c.zero?
            # make the URL cacheable for +c+ seconds *on average*
            t = ((t / c.to_f).round + 1) * c.to_i
          end
        else
          t = e.to_i
        end

        r, q = u[0, 1] == '/' ? u.split('?', 2) : URI.split(u).values_at(5, 7)
        r << '?' << q if q

        u.sub(/#|\z/, "#{q ? '&' : '?'}#{TOKEN_KEY}=#{join(t, token(s, r, t))}\\&")
      end

      # Joins +timestamp+ and +token+ parameters into a single value.
      def join(timestamp, token)
        "#{"%0#{TIMESTAMP_LENGTH}x" % timestamp}#{token}"
      end

      # Splits +value+ into timestamp and token parameters.
      def split(value)
        [value[0, TIMESTAMP_LENGTH].to_i(16), value[TIMESTAMP_LENGTH, TOKEN_LENGTH]]
      end

      # Computes the token from +secret+, +path+, and +timestamp+.
      def token(secret, path, timestamp)
        Digest::SHA1.hexdigest("#{secret}#{real_path(path)}#{timestamp}")
      end

      # Returns +path+ with timestamp and token parameter removed.
      def real_path(path)
        clean(path, :path)
      end

      # Returns +query+ with timestamp and token parameter removed.
      def real_query(query)
        clean(query, :query)
      end

      private

      # Returns +string+ with timestamp and token parameter removed.
      # The +type+ indicates whether it's a _path_ or a _query_.
      def clean(string, type)
        char = case type
          when :path  then '\?'
          when :query then '\A'
          else raise ArgumentError, "type #{type.inspect} not supported"
        end

        string.sub(/(#{char}|&)_asd=[^&]*(&?)/) { $1 unless $2.empty? }
      end

    end

  end

end

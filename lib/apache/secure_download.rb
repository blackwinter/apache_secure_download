#--
###############################################################################
#                                                                             #
# apache_secure_download -- Apache module providing secure downloading        #
#                           functionality                                     #
#                                                                             #
# Copyright (C) 2008 University of Cologne,                                   #
#                    Albertus-Magnus-Platz,                                   #
#                    50932 Cologne, Germany                                   #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@uni-koeln.de>                                    #
#                                                                             #
# apache_secure_download is free software: you can redistribute it and/or     #
# modify it under the terms of the GNU General Public License as published by #
# the Free Software Foundation, either version 3 of the License, or (at your  #
# option) any later version.                                                  #
#                                                                             #
# apache_secure_download is distributed in the hope that it will be useful,   #
# but WITHOUT ANY WARRANTY; without even the implied warranty of              #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General    #
# Public License for more details.                                            #
#                                                                             #
# You should have received a copy of the GNU General Public License along     #
# with apache_secure_download. If not, see <http://www.gnu.org/licenses/>.    #
#                                                                             #
###############################################################################
#++

require 'rubygems'
require 'apache/secure_download/util'

module Apache

  class SecureDownload

    # Creates a new RubyAccessHandler instance for the Apache web server.
    # The argument +secret+ is the shared secret string that the application
    # uses to create valid URLs (tokens).
    def initialize(secret, options = {})
      @secret = secret
      @deny   = options[:deny]
      @allow  = options[:allow]

      raise ArgumentError, 'secret string missing'  unless @secret.is_a?(String)
      raise ArgumentError, ':deny is not a regexp'  unless @deny.nil?  || @deny.is_a?(Regexp)
      raise ArgumentError, ':allow is not a regexp' unless @allow.nil? || @allow.is_a?(Regexp)
    end

    # Checks whether the current +request+ satisfies the following requirements:
    #
    # 1. The expiration time lies in the future (i.e., not expired)
    # 2. The token is valid for the requested URL and the given timestamp
    #
    # If either condition doesn't hold true, access to the requested resource
    # is denied!
    def check_access(request)
      uri, timestamp = request.uri, request.param('timestamp')

      if (@deny  && uri =~ @deny)  || (
        !(@allow && uri =~ @allow) && (
          timestamp.to_i < Time.now.to_i || request.param('token') != Util.token(
            @secret, request.unparsed_uri, timestamp
          )
        )
      )
        return FORBIDDEN
      else
        return OK
      end
    end

  end

end

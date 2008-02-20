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

    def initialize(secret)
      raise ArgumentError, 'secret string missing' unless @secret = secret
    end

    def check_access(request)
      timestamp = request.param('timestamp')

      return FORBIDDEN if timestamp.to_i < Time.now.to_i
      return FORBIDDEN if request.param('token') != Util.token(@secret, request.uri, timestamp)

      return OK
    end

  end

end

##
#
##

require 'exceptions/exceptions'

module Record
  ##
  #
  ##
  class Error < Sensly::Error
  end

  ##
  #
  ##
  class UpdateError < Error
  end

  ##
  #
  ##
  class UserAuthError < Error
    attr_reader :attribute

    def initialize(message = nil)
      @attribute = 'password'
      super message
    end
  end

  ##
  #
  ##
  class GroupMemberError < Error
  end

  ##
  #
  ##
  class DeviceRegistrationError < Error
  end

  ##
  #
  ##
  class DeviceAuthError < Error
  end

  ##
  #
  ##
  class ConcMissingError < Error
  end

  ##
  #
  ##
  class UserUnconfirmedError < Error
  end
end

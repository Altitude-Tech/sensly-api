##
#
##
class Key < ApplicationRecord
  ##
  # Validations
  ##
  validates(:public_key, uniqueness: true)
  validates(:private_key, presence: true)
  validates(:type, presence: true)
  validates(:expires, presence: true)
  validates(:valid, presence: true)

  ##
  # Constants
  ##

  # api tokens for... (developers?)
  # device tokens for registering devices (use qr codes?)
  # email tokens for confirming an email change/registration (figure out how to deal with forgotten email)
  # session tokens for sessions in sensly app/website
  # password reset tokens for resetting a password

  # @todo figure out public & private key for hmac

  TYPE_API = 1
  TYPE_DEVICE = 2
  TYPE_EMAIL = 3
  TYPE_PASSWORD_RESET = 4
  TYPE_SESSION = 5

  TYPES = [TYPE_API, TYPE_DEVICE, TYPE_EMAIL, TYPE_PASSWORD_RESET, TYPE_SESSION].freeze

  ##
  #
  ##
  def generate_token
  end

  ##
  #
  ##
  def set_defaults
  end

  ##
  #
  ##
  def valid?
  end
end
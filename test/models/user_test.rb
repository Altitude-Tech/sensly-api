##
#
##

require 'test_helper'

##
#
##
class UserTest < ActiveSupport::TestCase
  ##
  #
  ##
  BASE_DATA =  {
    name: 'test user',
    email: 'test@example.com',
    password: 'password'
  }.freeze

  ##
  # Test create success
  ##
  test 'create success' do
    data = BASE_DATA.deep_dup

    User.create!(data)
  end

  ##
  # Test create error handling of no password
  ##
  test 'create no password' do
    data = BASE_DATA.deep_dup
    data.delete(:password)

    assert_raises(ActiveRecord::RecordInvalid) do
      User.create!(data)
    end
  end

  ##
  # Test create error handling password below minimum length
  ##
  test 'create too short password' do
    data = BASE_DATA.deep_dup
    data[:password] = 'short'

    assert_raises(ActiveRecord::RecordInvalid) do
      User.create!(data)
    end
  end

  ##
  # Test create error handling password above max length (set by bcrypt)
  ##
  test 'create too long password' do
    data = BASE_DATA.deep_dup
    data[:password] = 'x' * 73

    assert_raises(ActiveRecord::RecordInvalid) do
      User.create!(data)
    end
  end

  ##
  # Test create error handling for invalid email address
  ##
  test 'create invalid email' do
    data = BASE_DATA.deep_dup
    data[:email] = 'invalid'

    assert_raises(ActiveRecord::RecordInvalid) do
      User.create!(data)
    end
  end

  ##
  # Test create error handling for missing email address
  ##
  test 'create missing email' do
    data = BASE_DATA.deep_dup
    data.delete(:email)

    assert_raises(ActiveRecord::RecordInvalid) do
      User.create!(data)
    end
  end

  ##
  # Test create error handling for in use email address
  ##
  test 'create in use email' do
    user = User.first!
    data = BASE_DATA.deep_dup
    data[:email] = user.email

    assert_raises(ActiveRecord::RecordInvalid) do
      User.create!(data)
    end
  end

  ##
  # Test create error handling for too email
  ##
  test 'create too long email' do
    data = BASE_DATA.deep_dup
    data[:email] = '@' + ('x' * 256)

    assert_raises(ActiveRecord::RecordInvalid) do
      User.create!(data)
    end
  end

  ##
  # Test create error handling for missing name
  ##
  test 'create missing name' do
    data = BASE_DATA.deep_dup
    data.delete(:name)

    assert_raises(ActiveRecord::RecordInvalid) do
      User.create!(data)
    end
  end

  ##
  # Test create error handling for too long name
  ##
  test 'create too long name' do
    data = BASE_DATA.deep_dup
    data[:name] = 'x' * 256

    assert_raises(ActiveRecord::RecordInvalid) do
      User.create!(data)
    end
  end

  ##
  # Test create error handling with password_digest
  ##
  test 'create password_digest' do
    data = BASE_DATA.deep_dup
    data[:password_digest] = 'password_digest'

    assert_raises(ArgumentError) do
      User.create!(data)
    end
  end

  ##
  # Test successful authentication of user
  ##
  test 'authenticate successful' do
    password = 'password'
    user = User.first!

    actual = user.authenticate(password)

    assert_instance_of(User, actual)
    assert_equal('Bert Sesame', actual.name)
  end

  ##
  # Test incorrect authentication of user
  ##
  test 'authenticate incorrect' do
    password = 'invalid'
    user = User.first!

    actual = user.authenticate(password)

    assert_equal(false, actual)
  end

  ##
  # Test successful authentication of user with error raising method
  ##
  test 'authenticate successful with error' do
    password = 'password'
    user = User.first!

    actual = user.authenticate!(password)

    assert_instance_of(User, actual)
    assert_equal('Bert Sesame', actual.name)
  end

  ##
  # Test incorrect authentication of user with error raising method
  ##
  test 'authenticate incorrect with error' do
    password = 'invalid'
    user = User.first!

    assert_raises(ArgumentError) do
      user.authenticate!(password)
    end
  end

  ##
  # Test error handling for updating password_digest
  ##
  test 'update password_digest' do
    password_digest = 'invalid_password'
    user = User.first!

    assert_raises(ArgumentError) do
      user.update!(password_digest: password_digest)
    end
  end

  ##
  # Test update_details success for name
  ##
  test 'update_details name success' do
    name = 'Bob'
    user = User.first!

    user.update_details!(name: name)
  end

  ##
  # Test error handling of setting password in update_details
  ##
  test 'update_details set password' do
    password = 'password'
    user = User.first!

    assert_raises(ArgumentError) do
      user.update_details!(password: password)
    end
  end

  ##
  # Test error handling of setting password_digest in update_details
  ##
  test 'update_details set password_digest' do
    password_digest = 'password_digest'
    user = User.first!

    assert_raises(ArgumentError) do
      user.update_details!(password_digest: password_digest)
    end
  end

  ##
  # Test change_password success
  ##
  test 'change_password success' do
    old_password = 'password'
    new_password = 'new_password'
    user = User.first!

    user.change_password!(old_password, new_password)
  end

  ##
  # Test error handling of change_password with incorrect old_password
  ##
  test 'change_password incorrect old password' do
    old_password = 'incorrect'
    new_password = 'new_password'
    user = User.first!

    assert_raises(ArgumentError) do
      user.change_password!(old_password, new_password)
    end
  end

  ##
  # Test error handling of change_password with invalid new_password
  ##
  test 'change_password invalid new password' do
    old_password = 'password'
    new_password = 'short'
    user = User.first!

    assert_raises(ActiveRecord::RecordInvalid) do
      user.change_password!(old_password, new_password)
    end
  end

  ##
  # Test generation of session token and when it expires
  ##
  test 'generate session_token' do
    user = User.first!
    user.create_session_token!
    now = Time.now.utc
    expires = Time.parse(user.session_token.expires).utc
    diff = ((expires - now) / 1.hour).round

    assert_instance_of(Token, user.session_token)
    assert_equal(6, diff)
  end

  ##
  # Test find_by_session_token method success
  ##
  test 'find_by_session_token success' do
    user = User.first!
    user.create_session_token!
    token = user.session_token.token

    user2 = User.find_by_session_token!(token)

    assert_instance_of(User, user2)
    assert_equal(user, user2)
  end

  ##
  # Test find_by_session_token method with invalid token
  ##
  test 'find_by_session_token invalid token' do
    assert_raises(ActiveRecord::RecordNotFound) do
      User.find_by_session_token!('invalid')
    end
  end

  ##
  # Test find_by_session_token method with non-linked token
  ##
  test 'find_by_session_token non-linked token' do
    token = Token.first!

    assert_raises(ActiveRecord::RecordNotFound) do
      User.find_by_session_token!(token.token)
    end
  end
end

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# empty log file before running tests
log_file = File.expand_path('../../log/test.log', __FILE__)
File.open(log_file, 'w') {} if File.file?(log_file)

# make sure database is up to date before running tests
ActiveRecord::Migration.maintain_test_schema!

##
#
##
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests
  # in alphabetical order.
  fixtures :all
end

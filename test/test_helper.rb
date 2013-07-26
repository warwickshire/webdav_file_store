$:.unshift File.join(File.dirname(__FILE__),'..','lib')
$:.unshift File.join(File.dirname(__FILE__),'lib')

require 'minitest/autorun'
require 'webdav_file_store'

require 'active_record'
ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database =>  "test/db/test.sqlite3.db"

require 'active_record/fixtures'
require 'active_support'

class ActiveSupport::TestCase

  include ActiveRecord::TestFixtures

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :things

  # Add more helper methods to be used by all tests here...
end

fixture_path = File.join(File.dirname(__FILE__),"fixtures")
ActiveRecord::Fixtures.create_fixtures(fixture_path, :things)



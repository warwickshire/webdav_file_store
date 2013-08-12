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

  fixtures :things

end

fixture_path = File.join(File.dirname(__FILE__),"fixtures")
ActiveRecord::Fixtures.create_fixtures(fixture_path, :things)

WebdavFileStore::RemoteServer.settings(
  url: 'http://localhost/webdav/',
  user: 'foo',
  password: 'bar'
)

def connection
  @webdav_url = WebdavFileStore::RemoteServer.url
  @connection ||= WebdavFileStore::Connection.new(@webdav_url, user: WebdavFileStore::RemoteServer.user, password: WebdavFileStore::RemoteServer.password)
end



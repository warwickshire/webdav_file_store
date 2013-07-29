
class Thing < ActiveRecord::Base

  before_save :save_file_to_webdav


  def save_file_to_webdav
    connection.put('things/1/thing.txt', file: attachment)
    self.attachment = 'thing.txt'
  end

  def connection
    webdav_url = 'http://localhost/webdav'
    @connection ||= WebdavFileStore::Connection.new(webdav_url, user: 'foo', password: 'bar')
  end
end

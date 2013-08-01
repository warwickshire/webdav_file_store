require_relative 'webdav_file_store/connection'
require_relative 'webdav_file_store/methods'
require_relative 'webdav_file_store/remote_server'
require_relative 'webdav_file_store/string_file'

module WebdavFileStore

end

require 'active_record'
ActiveRecord::Base.send(:extend, WebdavFileStore::Methods::ClassMethods)
require_relative 'webdav_file_store/connection'
require_relative 'webdav_file_store/methods'

module WebdavFileStore

end

require 'active_record'
ActiveRecord::Base.send(:extend, WebdavFileStore::Methods::ClassMethods)
$:.unshift File.join(File.dirname(__FILE__),'..','lib')
$:.unshift File.join(File.dirname(__FILE__),'lib')

require 'minitest/autorun'
require 'webdav_file_store'

require 'active_record'
ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database =>  "test/db/test.sqlite3.db"

require_relative '../test_helper'
require 'thing'

class ThingTest < ActiveSupport::TestCase

  def setup
    @string = 'this'
    @thing = Thing.find(1)
    @file = File.open(File.expand_path("../../files/demo.txt", __FILE__))
  end

  def teardown
    @file.close if @file
    connection.rmdir('things')
  end

  def test_setup
    assert_equal 'Foo', @thing.name
  end

  def test_populate_webdav_file_stores
    @thing.attachment = @string
    @thing.populate_webdav_file_stores
    assert_equal(nil, @thing.webdav_file_stores[:attachment])
  end

  def test_populate_webdav_file_stores_with_file
    @thing.attachment = @file
    @thing.populate_webdav_file_stores
    assert_equal(@file, @thing.webdav_file_stores[:attachment][:file])
  end

  def test_replace_webdav_file_store_attributes_with_file_names
    test_populate_webdav_file_stores_with_file
    @thing.replace_webdav_file_store_attributes_with_file_names
    assert_equal(File.basename(@file), @thing.attachment)
  end

  def test_path_to_webdav_stored_file
    attribute = :attachment
    file_name = File.basename(@file)
    expected = "things/#{@thing.id}/#{attribute}/#{file_name}"
    assert_equal(expected, @thing.path_to_webdav_stored_file(attribute, file_name))
  end

  def test_paths_created_when_web_webdav_file_stores_populated
    test_populate_webdav_file_stores_with_file
    expected = @thing.path_to_webdav_stored_file(:attachment, File.basename(@file))
    assert_equal(expected, @thing.webdav_file_stores[:attachment][:path])
  end

  def test_file_sent_to_webdav_on_save
    assert_attachment_not_in_webdav
    @thing.attachment = @file
    @thing.save
    connection = @thing.webdav_file_stores[:attachment][:connection]
    assert_match(/20\d/, connection.response.code, connection.response.body)
    @path = @thing.webdav_file_stores[:attachment][:path]
    assert_attachment_in_webdav
  end

  def assert_attachment_not_in_webdav
#    assert_equal('404', connection.get(@thing.path_to_file).response.code)
  end

  def assert_attachment_in_webdav
    assert_match(/20\d/, connection.get(@path).response.code)
  end
end

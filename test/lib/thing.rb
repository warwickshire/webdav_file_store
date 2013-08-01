
class Thing < ActiveRecord::Base

  has_webdav_file_store :attachment

end

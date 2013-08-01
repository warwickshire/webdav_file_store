
module WebdavFileStore
  module Methods
    module ClassMethods

      def has_webdav_file_store(*names)
        store_webdav_file_store_attributes(names)
        configure_host_class_to_work_with_webdav_file_store
      end

      def webdav_file_store_attributes
        @webdav_file_store_attributes
      end

      private
      def store_webdav_file_store_attributes(names)
        @webdav_file_store_attributes ||= []
        @webdav_file_store_attributes += names
        @webdav_file_store_attributes.uniq!
      end

      def configure_host_class_to_work_with_webdav_file_store
        include WebdavFileStore::Methods::InstanceMethods
        before_save :store_webdav_file_locally
        after_save :save_file_to_webdav
      end
    end
  end
end

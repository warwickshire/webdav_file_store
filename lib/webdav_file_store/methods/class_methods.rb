
module WebdavFileStore
  module Methods
    module ClassMethods

      def has_webdav_file_store(*names)
        store_webdav_file_store_attributes(names)
        configure_host_class_to_work_with_webdav_file_store
        make_getters_for_webdav_file_stores_return_string_files(names)
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

      def make_getters_for_webdav_file_stores_return_string_files(fields)
        for field in fields
          define_method field.to_sym do
            content = attributes[field.to_s]

            return content unless content.kind_of? String

            WebdavFileStore::StringFile.new(
              content,
              webdav_connection,
              path_to_webdav_stored_file(field.to_sym, content)
            )
          end
        end
      end
    end
  end
end

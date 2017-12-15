module ActiveAdmin
  module Exporter
    class Railtie < ::Rails::Railtie
      config.after_initialize do
        begin
          if Mime::Type.lookup_by_extension(:email).nil?
            Mime::Type.register 'application/email_export', :email, []
          end
        rescue NameError
          # noop
        end

        ActiveAdmin::ResourceController.class_eval do
          include ActiveAdmin::Exporter::ResourceControllerExtension
        end
        ActiveAdmin::Views::PaginatedCollection.add_format :email
      end
    end
  end
end

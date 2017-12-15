module ActiveAdmin
  module Exporter
    module ResourceControllerExtension
      def self.included(base)
        base.send(:alias_method, :index_without_email, :index)
        base.send(:alias_method, :index, :index_with_email)

        base.send(:respond_to, :email)
      end

      def index_with_email
        index_without_email do |format|
          format.email do
            current_user_method = active_admin_config.namespace.application.current_user_method
            recipient_email     = send(current_user_method).email
            class_name          = self.class.to_s

            ActiveAdmin::Exporter::ExporterMailer.csv_export(
              recipient_email,
              class_name,
              params.to_json
            ).deliver_later

            redirect_back(fallback_location: root_path, notice: "CSV export emailed to #{recipient_email}!")
          end
        end
      end
    end
  end
end

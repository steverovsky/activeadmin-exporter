module ActiveAdmin
  module Exporter
    class ExporterMailer < ActionMailer::Base
      DEFAULT_TEMPLATE_PATH = '/admin_mailer'.freeze
      DEFAULT_TEMPLATE_NAME = 'message_export'.freeze

      layout 'mailer'

      def csv_export(recipient_email, class_name, params_json)
        params     = JSON.parse(params_json)
        controller = class_name.constantize.new
        controller.send('params=', params.merge(email: recipient_email))

        config       = controller.send(:active_admin_config)
        csv_filename = controller.send(:csv_filename)
        entity_name  = controller.send(:resource_collection_name)
        zip_filename = csv_filename.sub('.csv', '.zip')

        def controller.find_collection(options = {})
          options[:only] = %i[
            sorting
            filtering
            scoping
            includes
            pagination
            collection_decorator
          ]

          collection = scoped_collection
          collection_applies(options).each do |applyer|
            collection = send("apply_#{applyer}", collection)
          end
          collection
        end

        zip = Zip::OutputStream.write_buffer do |zio|
          zio.put_next_entry(csv_filename)
          config.csv_builder.build(controller, zio)
        end

        attachments[zip_filename] = zip.string
        subject                   = I18n.t(
          'message.active_admin_export_subject',
          entity_name: entity_name.to_s.humanize,
          default:     zip_filename
        )

        mail(
          layout: 'mailer',
          to: recipient_email,
          subject: subject,
          from:          ActiveAdmin::Exporter.from_email_address,
          template_path: DEFAULT_TEMPLATE_PATH,
          template_name: DEFAULT_TEMPLATE_NAME
        )
      end
    end
  end
end

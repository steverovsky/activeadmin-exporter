module ActiveAdmin
  module Exporter
    class ExporterMailer < ActionMailer::Base
      def csv_export(recipient_email, class_name, params_json)
        params     = JSON.parse(params_json)
        controller = class_name.constantize.new
        controller.send('params=', params)

        config       = controller.send(:active_admin_config)
        csv_filename = controller.send(:csv_filename)
        zip_filename = csv_filename.sub('.csv', '.zip')

        def controller.find_collection(options = {})
          options[:only] = [
            :sorting,
            :filtering,
            :scoping,
            :includes,
            :pagination,
            :collection_decorator
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

        mail(
          to: recipient_email,
          subject: zip_filename,
          body: 'See attached.',
          from: ActiveAdmin::Exporter.from_email_address
        )
      end
    end
  end
end

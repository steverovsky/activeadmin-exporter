require 'active_admin'
require 'active_admin/exporter/build_download_format_links'
require 'active_admin/exporter/version'
require 'active_admin/exporter/resource_controller_extension'
require 'active_admin/exporter/exporter_mailer'
require 'active_admin/exporter/railtie'
require 'rubygems'
require 'zip'

module ActiveAdmin
  module Exporter
    def self.from_email_address=(address)
      @from_email_address = address
    end

    def self.from_email_address
      @from_email_address || 'admin@example.com'
    end
  end
end

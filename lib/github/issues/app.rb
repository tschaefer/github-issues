# frozen_string_literal: true

require 'tty-table'

require 'github/issues/app/base'
require 'github/issues/app/year'
require 'github/issues/app/month'
require 'github/issues/app/labels'

module Github
  class Issues
    module App
      ##
      # Main command class
      class Command < BaseCommand
        option '--configuration-file', 'FILE', 'configuration file', attribute_name: :cfgfile
        option '--cache-path', 'PATH', 'cache path', attribute_name: :cachepath
        option '--refresh', 'INTERVAL', 'refresh interval (e.g., 30minutes, 2.5hours, 1day)'

        subcommand 'yearly', 'Show issues per year.', YearCommand
        subcommand 'monthly', 'Show issues per month.', MonthCommand
        subcommand 'labels', 'List all labels.', LabelsCommand
      end
    end
  end
end

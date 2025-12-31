# frozen_string_literal: true

require 'tty-table'

module Github
  class Issues
    module App
      ##
      # Mixin for table rendering
      module Table
        private

        ##
        # Renders the table for the issues statistics
        #
        # @param issues [Hash::Mash] Issues statistics data
        # @param finished [Boolean] Whether to include finished issues statistics
        #
        # @return [String] Rendered table as a string
        def table_create(issues, finished)
          header = table_header_create(finished)

          rows = issues.map do |year, data|
            table_row_create(year, data, finished)
          end
          table = TTY::Table.new(header, rows)

          table.render(multiline: true, width: 2**16) do |renderer|
            renderer.border do
              mid     '─'
              mid_mid '─'
              center  ' '
            end
          end
        end

        ##
        # Creates the table header
        #
        # @param finished [Boolean] Whether to include finished issues statistics
        #
        # @return [Array<String>] Table header
        def table_header_create(finished)
          period = self.class.name.split('::').last.sub('Command', '')
          header = [
            period
          ]

          header += %w[
            Created
            Closed
            Created-Closed-Ratio
            Closed-Avg
            Closed-Median
          ]

          return header unless finished

          header + %w[
            Finished
            Finished-Ratio
            Finished-Avg
            Finished-Median
          ]
        end

        ##
        # Creates a table row for a given period and data
        #
        # @param period [String] Period (year, month as integer)
        # @param data [Hash::Mash] Period data
        # @param finished [Boolean] Whether to include finished issues
        #
        # @return [Array] Table row
        def table_row_create(period, data, finished)
          stats = stats_as_days(data.stats)
          all = [
            period,
            data.created&.size || 0,
            data.closed&.size || 0,
            data.stats.ratio.all.round(2),
            stats.all_avg,
            stats.all_median
          ]

          return all unless finished

          all + [
            data.finished&.size || 0,
            data.stats.ratio.finished.round(2),
            stats_seconds_to_days(data.stats.close_time.finished.average),
            stats_seconds_to_days(data.stats.close_time.finished.median)
          ]
        end
      end
    end
  end
end

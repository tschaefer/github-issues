# frozen_string_literal: true

require 'hashie'

module Github
  class Issues
    module App
      ##
      # Mixin for statistics methods
      module Statistics
        private

        ##
        # Convert stats closing time from seconds to days
        #
        # @param stats [Hashie::Mash] Statistics data
        #
        # @return [Hashie::Mash] Statistics data with time in days
        def stats_as_days(stats)
          Hashie::Mash.new(
            {
              all_avg: stats_seconds_to_days(stats.close_time.all.average),
              all_median: stats_seconds_to_days(stats.close_time.all.median),
              finished_avg: stats_seconds_to_days(stats.close_time.finished.average),
              finished_median: stats_seconds_to_days(stats.close_time.finished.median)
            }
          )
        end

        ##
        # Convert seconds to days
        #
        # @param seconds [Integer] Time in seconds
        #
        # @return [Integer] Time in days
        def stats_seconds_to_days(seconds)
          (seconds / 60 / 60 / 24).round
        end
      end
    end
  end
end

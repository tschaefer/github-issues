# frozen_string_literal: true

module Github
  class Issues
    ##
    # Mixin for calculating issues statistics
    module Statistics
      private

      ##
      # Collects statistics about issues
      #
      # @param object [Hash] Hash containing :created, :closed, and :finished issue arrays
      #
      # @return [Hash] Hash containing calculated statistics
      def stats_combined(object)
        {
          ratio: {
            all: stats_closed_created_ratio(object[:closed], object[:created]),
            finished: stats_closed_created_ratio(object[:finished], object[:created])
          },
          close_time: {
            all: {
              average: stats_average_closing_time(object[:closed]),
              median: stats_median_closing_time(object[:closed])
            },
            finished: {
              average: stats_average_closing_time(object[:finished]),
              median: stats_median_closing_time(object[:finished])
            }
          }
        }
      end

      ##
      # Calculates the ratio of closed issues to created issues
      #
      # @param closed [Array<Hashie::Mash>] Array of closed issues
      # @param created [Array<Hashie::Mash>] Array of created issues
      #
      # @return [Float] Ratio of closed to created issues
      def stats_closed_created_ratio(closed, created)
        return 0 if created.nil? || created.empty? || closed.nil? || closed.empty?

        closed.size.to_f / created.size
      end

      ##
      # Calculates the average closing time for a set of issues
      #
      # @param closed [Array<Hashie::Mash>] Array of closed issues
      #
      # @return [Float] Average closing time in seconds
      def stats_average_closing_time(closed)
        return 0 if closed.nil? || closed.empty?

        total = closed.sum { |issue| issue.closed_at - issue.created_at }
        total.to_f / closed.size
      end

      ##
      # Calculates the median closing time for a set of issues
      #
      # @param closed [Array<Hashie::Mash>] Array of closed issues
      #
      # @return [Float] Median closing time in seconds
      def stats_median_closing_time(closed)
        return 0 if closed.nil? || closed.empty?

        times = closed.map { |issue| issue.closed_at - issue.created_at }
        times.sort!
        size = times.size
        (times[(size - 1) / 2] + times[size / 2]) / 2.0
      end
    end
  end
end

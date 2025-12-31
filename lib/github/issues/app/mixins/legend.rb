# frozen_string_literal: true

module Github
  class Issues
    module App
      ##
      # Mixin for legend creation
      module Legend
        private

        ##
        # Create a legend for the issues report
        #
        # @param issues [Array<Hash>] Issues data
        # @param extra [String, nil] Extra information to include in the legend
        #
        # @return [String] Legend string
        def legend_create(issues, legend, extra: nil)
          return "\n" unless legend

          created = 0
          closed = 0
          open = 0
          issues.each do |group|
            data = group.last

            created += data[:created].size
            closed += data[:closed].size
            open += data[:created].size - data[:closed].size
          end

          legend = "\n\n#{created} created. #{closed} closed. #{open} open."
          legend = "#{legend}\n#{extra}" if extra

          "#{legend}\n"
        end
      end
    end
  end
end

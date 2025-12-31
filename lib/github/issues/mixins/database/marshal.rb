# frozen_string_literal: true

require 'hashie'
require 'json'
require 'time'

module Github
  class Issues
    class Database
      ##
      # Mixin to marshal issue data from database format to Hashie::Mash
      module Marshal
        private

        ##
        # Marshal issue data from database format to Hashie::Mash
        #
        # @param issue [Hash] Issue data from database
        #
        # @return [Hashie::Mash] Marshaled issue data
        def marshal_issue(issue)
          Hashie::Mash.new(
            {
              id: issue['id'],
              created_at: Time.parse(issue['created_at']),
              closed_at: issue['closed_at'] ? Time.parse(issue['closed_at']) : nil,
              number: issue['number'],
              url: issue['url'],
              labels: JSON.parse(issue['labels'] || '[]'),
              state: issue['state']
            }
          )
        end
      end
    end
  end
end

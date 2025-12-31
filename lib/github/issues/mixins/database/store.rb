# frozen_string_literal: true

module Github
  class Issues
    class Database
      ##
      # Mixin for storing issues and metadata in the database
      module Store
        private

        ##
        # Store an issue in the database
        #
        # @param connection [SQLite3::Database] Database connection
        # @param issue [Sawyer::Ressource] Issue to store
        #
        # @return [void]
        def store_issue(connection, issue)
          if store_issue_exist?(connection, issue.number)
            store_update_issue(connection, issue)
          else
            store_insert_issue(connection, issue)
          end
        end

        ##
        # Store metadata in the database
        #
        # @param connection [SQLite3::Database] Database connection
        # @param key [String] Metadata key
        # @param value [String] Metadata value
        #
        # @return [void]
        def store_metadata(connection, key, value)
          connection.execute(
            'INSERT OR REPLACE INTO metadata (key, value) VALUES (?, ?)',
            [key, value]
          )
        end

        ##
        # Check if an issue exists in the database
        #
        # @param connection [SQLite3::Database] Database connection
        # @param issue_number [Integer] Issue number
        #
        # @return [Boolean] True if the issue exists, false otherwise
        def store_issue_exist?(connection, issue_number)
          existing = connection.get_first_row(
            'SELECT id FROM issues WHERE number = ?',
            issue_number
          )
          !existing.nil?
        end

        ##
        # Update an existing issue in the database
        #
        # @param connection [SQLite3::Database] Database connection
        # @param issue [Github::Issue] Issue to update
        #
        # @return [void]
        def store_update_issue(connection, issue)
          connection.execute(
            'UPDATE issues SET (created_at, closed_at, url, labels, state) = (?, ?, ?, ?, ?)  WHERE number = ?',
            [
              issue.created_at.utc.iso8601,
              issue.closed_at.nil? ? nil : issue.closed_at.utc.iso8601,
              issue.html_url,
              issue.labels.map(&:name).to_json,
              issue.state,
              issue.number
            ]
          )
        end

        ##
        # Insert a new issue into the database
        #
        # @param connection [SQLite3::Database] Database connection
        # @param issue [Github::Issue] Issue to insert
        #
        # @return [void]
        def store_insert_issue(connection, issue)
          connection.execute(
            'INSERT INTO issues (created_at, closed_at, url, labels, state, number) VALUES (?, ?, ?, ?, ?, ?)',
            [
              issue.created_at.utc.iso8601,
              issue.closed_at.nil? ? nil : issue.closed_at.utc.iso8601,
              issue.html_url,
              issue.labels.map(&:name).to_json,
              issue.state,
              issue.number
            ]
          )
        end
      end
    end
  end
end

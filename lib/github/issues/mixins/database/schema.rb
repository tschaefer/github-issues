# frozen_string_literal: true

module Github
  class Issues
    class Database
      ##
      # Mixin for creating database schema
      module Schema
        private

        ##
        # Creates the database schema for issues and metadata tables
        #
        # @param connection [SQLite3::Database] Database connection
        def schema_create(connection)
          connection.execute <<-SQL
          CREATE TABLE IF NOT EXISTS issues (
            id INTEGER PRIMARY KEY,
            created_at TEXT NOT NULL,
            closed_at TEXT,
            number INTEGER UNIQUE NOT NULL,
            url TEXT NOT NULL,
            labels TEXT,
            state TEXT NOT NULL
          )
          SQL

          connection.execute <<-SQL
          CREATE TABLE IF NOT EXISTS metadata (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
          )
          SQL
        end
      end
    end
  end
end

module Radiant
  class ExtensionMigrator < ActiveRecord::Migrator
    class << self
      attr_accessor :extension

      def migrate(target_version = nil)
        super extension.migrations_path, target_version
      end
      
      def migrate_extensions
        Rails.configuration.extensions_in_order.each do |ext|
          to_migrate = Extension.descendants.detect{|descendant| descendant.name == "#{ext.to_s.camelize}Extension" }
          to_migrate.migrator.migrate
        end
      end

      def get_all_versions
        ActiveRecord::Base.connection.select_values("SELECT version FROM #{schema_migrations_table_name}").
          select { |version| version.starts_with?("#{@extension.extension_name}-")}.
          map { |version| version.sub("#{@extension.extension_name}-", '').to_i }.sort
      end
    end
    
    def initialize(direction, migrations_path, target_version = nil)
      super
      initialize_extension_schema_migrations
      initialize_replaced_migrations
    end
    
    private
      def quote(s)
        ActiveRecord::Base.connection.quote(s)
      end
      
      def extension_name
        self.class.extension.extension_name
      end
      
      def version_string(version)
        "#{extension_name}-#{version}"
      end
      
      def initialize_extension_schema_migrations
        current_version = ActiveRecord::Base.connection.select_value("SELECT schema_version FROM extension_meta WHERE name = #{quote(extension_name)}")
        if current_version
          assume_migrated_upto_version(current_version.to_i) 
          ActiveRecord::Base.connection.delete("DELETE FROM extension_meta WHERE name = #{quote(extension_name)}")
        end
      end

      def initialize_replaced_migrations
        if old_extension_name = self.class.extension.replaces
          if last_replaced_migration = ActiveRecord::Base.connection.select_values("SELECT version FROM #{ActiveRecord::Migrator.schema_migrations_table_name} WHERE version LIKE '#{old_extension_name}-%'").map{|v| v.sub(/^#{old_extension_name}\-/, '').to_i}.max
            assume_migrated_upto_version(last_replaced_migration.to_i)
            # we don't delete the old migrations so that the replacement can be reversed
          end
        end
      end
      
      def assume_migrated_upto_version(version)
        version = version.to_i
        sm_table = self.class.schema_migrations_table_name

        migrated = self.class.get_all_versions
        versions = Dir["#{@migrations_path}/[0-9]*_*.rb"].map do |filename|
          filename.split('/').last.split('_').first.to_i
        end

        unless migrated.include?(version)
          ActiveRecord::Base.connection.execute "INSERT INTO #{sm_table} (version) VALUES (#{quote(version_string(version))})"
        end

        inserted = Set.new
        (versions - migrated).each do |v|
          if inserted.include?(v)
            raise "Duplicate migration #{v}. Please renumber your migrations to resolve the conflict."
          elsif v < version
            ActiveRecord::Base.connection.execute "INSERT INTO #{sm_table} (version) VALUES (#{quote(version_string(v))})"
            inserted << v
          end
        end
      end
      
      def record_version_state_after_migrating(version)
        sm_table = self.class.schema_migrations_table_name

        @migrated_versions ||= []
        if down?
          @migrated_versions.delete(version.to_i)
          ActiveRecord::Base.connection.update("DELETE FROM #{sm_table} WHERE version = #{quote(version_string(version))}")
        else
          @migrated_versions.push(version.to_i).sort!
          ActiveRecord::Base.connection.insert("INSERT INTO #{sm_table} (version) VALUES (#{quote(version_string(version))})")
        end
      end
  end
end

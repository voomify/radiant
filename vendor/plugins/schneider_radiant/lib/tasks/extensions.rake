require "schema_utils"
require 'replace_rake_tasks'
require 'rake/testtask'

include SchemaUtils

namespace :db do

  def postgres_desc(description)
        desc description + "\n" + "Can only work on databases that support schemas. Postgresql is the only one implemented right now."
  end

  namespace :migrate do
    postgres_desc "Run all Radiant extension migrations"
    override_task :extensions => :environment do
      puts "Migrating all schemas"
      check_adapter do
        run_on_all_schemas do |schema|
          puts "Running migration #{schema}"
          require 'radiant/extension_migrator'
          Radiant::ExtensionMigrator.migrate_extensions
          Rake::Task['db:schema:dump'].invoke
        end
      end      
    end
  end
end
namespace :db do
  task setup_if_not_yet: [:environment] do
    begin
      if !ActiveRecord::SchemaMigration.table_exists?
        # database exists but tables not exists
        Rake::Task["db:setup"].invoke
        exit 0
      end
    rescue ActiveRecord::NoDatabaseError
      # database not exists
      Rake::Task["db:setup"].invoke
      exit 0
    end
  end

  task wait_for_setup_completion: [:environment] do
    loop do
      begin
        if !ActiveRecord::InternalMetadata.table_exists?
          # database exists but tables not exists
          sleep 1
        elsif !ActiveRecord::InternalMetadata.where(key: :environment).exists?
          # tables exists but setup is not completed yet
          sleep 1
        else
          break
        end
      rescue ActiveRecord::NoDatabaseError
        # database not exists
        sleep 1
      end
    end
  end

  task try_migrate: [:wait_for_setup_completion] do
    begin
      Rake::Task["db:migrate"].invoke
    rescue ActiveRecord::ConcurrentMigrationError => e
      Rails.logger.info e.message
    end
  end
end

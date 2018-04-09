namespace :db do
  task setup_if_not_yet: [:environment] do
    begin
      ActiveRecord::Base.connection
    rescue ActiveRecord::NoDatabaseError
      # database not exists
      Rake::Task["db:setup"].invoke
      exit 0
    else
      if !ActiveRecord::SchemaMigration.table_exists?
        # database exists but tables not exists
        Rake::Task["db:setup"].invoke
        exit 0
      end
    end
  end
end

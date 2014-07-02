task sync: :environment do
  Mn3njalnik.connection = Mn3njalnik::Connection.
    new(logger: Logger.new(File.join(Rails.root, "log", "mn3njalnik.log")))
  Mn3njalnik.connection.login(CONFIG[:mn3njalnik][:username],
                              CONFIG[:mn3njalnik][:password])
  lock_file = File.join(Rails.root, "tmp", "sync.lock")
  raise "sync already in progress somewhere else" if File.exists?(lock_file)
  begin
    lock = FileUtils.touch(lock_file)
    Topic.sync_all
  ensure
    FileUtils.rm(lock)
  end
end

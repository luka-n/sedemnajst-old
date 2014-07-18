module SyncLog
  extend ActiveSupport::Concern

  included do
    delegate :sync_log, to: :"self.class"
  end

  module ClassMethods
    def sync_log
      @sync_log ||= Logger.new(File.join(Rails.root, "log", "sync.log"))
    end
  end
end

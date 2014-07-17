module UpdatedAtTrigger
  extend ActiveSupport::Concern

  included do
    trigger.before(:update) do
      "NEW.updated_at := now()"
    end
  end
end

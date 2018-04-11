class NotifyUpdateJob < ApplicationJob
  queue_as :default

  def perform(data)
    ActionCable.server.broadcast "notification_channel", message: data
  end
end

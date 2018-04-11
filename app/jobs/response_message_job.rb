class ResponseMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    Message.create!(body: message.body.reverse)
  end
end

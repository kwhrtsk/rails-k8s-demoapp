# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  body       :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Message < ApplicationRecord
  MAX_BODY_LENGTH = 140

  validates :body,
    presence: true,
    length: { maximum: MAX_BODY_LENGTH }

  after_create do
    NotifyUpdateJob.perform_later(body)
  end
end

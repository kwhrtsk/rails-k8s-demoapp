# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  body       :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Message, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

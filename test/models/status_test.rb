# == Schema Information
#
# Table name: statuses
#
#  id         :integer          not null, primary key
#  app_id     :integer          not null
#  hostname   :string           not null
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  statuses_index_on_3columns  (app_id,hostname,updated_at)
#

require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

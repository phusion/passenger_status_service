# == Schema Information
#
# Table name: apps
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  name       :string           not null
#  api_token  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_apps_on_api_token  (api_token) UNIQUE
#

require 'test_helper'

class AppTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

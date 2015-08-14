# == Schema Information
#
# Table name: hosts
#
#  id         :integer          not null, primary key
#  app_id     :integer          not null
#  hostname   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_hosts_on_app_id_and_hostname  (app_id,hostname) UNIQUE
#

require 'test_helper'

class HostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

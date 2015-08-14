# == Schema Information
#
# Table name: statuses
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  host_id    :integer          not null
#
# Indexes
#
#  index_statuses_on_host_id_and_updated_at  (host_id,updated_at)
#

class Status < ActiveRecord::Base
  belongs_to :host, inverse_of: 'statuses'

  validates :content, presence: true

  def app
    host.try(:app)
  end

  def user_id
    host.try(:user_id)
  end

  def hostname
    host.try(:hostname)
  end
end

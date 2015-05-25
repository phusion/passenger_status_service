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

class Status < ActiveRecord::Base
  belongs_to :app, inverse_of: 'statuses'

  scope :group_by_hostname_and_time, lambda { |app_id|
    joins(%Q{
      INNER JOIN (
        SELECT MAX(updated_at) AS max_updated_at
        FROM statuses
        WHERE statuses.app_id = #{app_id.to_i}
        GROUP BY hostname
      ) statuses2
      ON statuses.updated_at = statuses2.max_updated_at
    }).group(:hostname).order(:hostname)
  }

  validates :hostname, :content, presence: true
end

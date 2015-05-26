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
    result = joins(%Q{
      INNER JOIN (
        SELECT MAX(updated_at) AS max_updated_at
        FROM statuses
        WHERE statuses.app_id = #{app_id.to_i}
        GROUP BY hostname
      ) statuses2
      ON statuses.updated_at = statuses2.max_updated_at
    }).order(:hostname)
    if Status.connection.adapter_name == "PostgreSQL"
      result.select("distinct on (hostname), statuses.*")
    else
      result
    end
  }

  validates :hostname, :content, presence: true

  def user_id
    app.user_id
  end
end

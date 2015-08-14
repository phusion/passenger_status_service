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

class Host < ActiveRecord::Base
  belongs_to :app, inverse_of: 'hosts'
  has_many :statuses, -> { order('statuses.updated_at DESC') }, inverse_of: 'host'

  validates :hostname, presence: true

  def new_status_report_from_api_params(params)
    if params[:content].respond_to?(:read)
      content = params[:content].read
    else
      content = params[:content]
    end
    statuses.new(content: content)
  end

  def clean_old_status_reports
    statuses.where(["updated_at < ?", RETENTION_TIME.ago]).delete_all
  end
end

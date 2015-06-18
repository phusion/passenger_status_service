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

class App < ActiveRecord::Base
  belongs_to :user, inverse_of: 'apps'
  has_many :statuses, inverse_of: 'app'

  default_value_for(:api_token) { App.generate_api_token }

  attr_accessor :terms_of_service

  validates :name, :api_token, presence: true
  validates :terms_of_service, presence: true, acceptance: true, if: :new_record?

  def self.generate_api_token
    time   = Time.now.to_i.to_s(36).ljust(8, "-")
    random = SecureRandom.random_number(2**96).to_s(36).ljust(19, "0")
    "#{time}#{random}"
  end

  def new_status_report_from_api_params(params)
    if params[:content].respond_to?(:read)
      content = params[:content].read
    else
      content = params[:content]
    end
    statuses.new(
      hostname: params[:hostname].try(:downcase),
      content: content
    )
  end

  def clean_old_status_reports_from_api_params(params)
    hostname = params[:hostname].downcase
    statuses.where(["hostname = ? AND updated_at < ?", hostname, RETENTION_TIME.ago]).delete_all
  end
end

class App < ActiveRecord::Base
  belongs_to :user, inverse_of: 'apps'
  has_many :statuses, inverse_of: 'app'

  attr_accessor :accept_tos

  default_value_for(:api_token) { App.generate_api_token }

  def self.generate_api_token
    time   = Time.now.to_i.to_s(36).ljust(8, "-")
    random = SecureRandom.random_number(2**96).to_s(36).ljust(19, "0")
    "#{time}#{random}"
  end
end

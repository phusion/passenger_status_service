class Status < ActiveRecord::Base
  belongs_to :app, inverse_of: 'statuses'

  validates :namespace, :hostname, :content, presence: true

  def self.new_from_params(params)
    status = new
    status.accept_tos = params[:i_accept_the_terms_of_service] == 'true'
    status.namespace = params[:namespace].downcase
    status.hostname = params[:hostname].downcase
    status.password = params[:password].downcase
    status.password_confirmation = params[:password].downcase
    status.content  = params[:content]
    status
  end

  def self.find_by_params(params)
    find_by(
      namespace: params[:namespace].downcase,
      hostname: params[:hostname].downcase
    )
  end

  def accept_tos?
    !!@accept_tos
  end
end

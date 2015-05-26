class WelcomeController < ApplicationController
  around_filter :allow_http_private_caching, only: [:index, :faq, :tos]

  skip_authorization_check
end

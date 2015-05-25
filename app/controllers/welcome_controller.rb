class WelcomeController < ApplicationController
  # We don't do this because the navbar is not cacheable.
  # around_filter :allow_http_caching, only: [:index, :faq, :tos]
end

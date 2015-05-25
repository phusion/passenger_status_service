class WelcomeController < ApplicationController
  around_filter :allow_http_caching, only: [:index, :faq, :tos]
end

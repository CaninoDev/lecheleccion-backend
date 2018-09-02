class ApplicationController < ActionController::API
  include Response
  include Bias
  include Aylien
end

class ApplicationController < ActionController::Base

  USERS = { ENV["USER_NAME"] => ENV["PASSWORD"]}

  #before_action :basic_authentication
  before_action :digest_auth, if: -> { request.path == '/' || request.path == '/manager' || request.path == '/users/sign_in' || request.path == '/users/sign_up' }
  before_action :authenticate_user!, except: [:top]

  def after_sign_in_path_for(resource)
  days_path
  end

  def after_sign_out_path_for(resource)
  root_path
  end

  private
  def digest_auth
    authenticate_or_request_with_http_digest do |user|
      USERS[user]
    end
  end

  #def basic_authentication
    #authenticate_or_request_with_http_basic do |user_name, password|
      #user_name ==ENV["USER_NAME"] && password == ENV["PASSWORD"]
    #end
  #end
end
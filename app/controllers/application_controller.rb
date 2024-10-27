class ApplicationController < ActionController::Base

  before_action :basic_authentication
  before_action :authenticate_user!, except: [:top]

  def after_sign_in_path_for(resource)
  days_path
  end

  def after_sign_out_path_for(resouce)
  root_path
  end

  private
  def basic_authentication
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name ==ENV["USER_NAME"] && password == ENV["PASSWORD"]
    end
  end
end

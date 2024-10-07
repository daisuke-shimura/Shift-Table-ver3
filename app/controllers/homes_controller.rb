class HomesController < ApplicationController
  def top
    @user = User.all
  end
end

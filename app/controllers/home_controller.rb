class HomeController < ApplicationController
  before_action :allow_request

  def index
  end

  private

  def allow_request
    redirect_to results_path if cookies[:completed]
  end
end

class HomeController < ApplicationController
  before_action :require_login
  before_action :require_payment

  def index
  end
end

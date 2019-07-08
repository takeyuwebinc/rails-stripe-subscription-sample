class InvoicesController < ApplicationController
  before_action :require_login

  def index
    @invoices = current_user.invoices
  end

  def show
    @invoice = current_user.invoices.find(params[:id])
  end
end

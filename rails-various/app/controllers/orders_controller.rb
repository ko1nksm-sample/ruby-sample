class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :destroy]

  def index
    @orders = Order.all
  end

  def show
  end

  def create
    @order = Order.create(order_params)
    redirect_to @order
  end

  def destroy
    @order.destroy
    redirect_to orders_url
  end

  private
    def order_params
      params.require(:order).permit(:name, :address)
    end

    def set_order
      @order = Order.find(params[:id])
    end
end

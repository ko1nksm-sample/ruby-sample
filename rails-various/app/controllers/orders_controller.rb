class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.create(order_params)
    redirect_to @order
  end

  private
    def order_params
      params.require(:order).permit(:name, :address)
    end
end

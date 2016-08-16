class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.all.eager_load(:details)
  end

  def new
    @order = Order.new
    @order.details.build
  end

  def show
  end

  def edit
  end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: 'Order was successfully updated.'
    else
      render :edit
    end
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to @order
    else
      render :new
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: 'Order was successfully destroyed.'
  end

  private
    def order_params
      params.require(:order).permit(:name, :address,
        :details_attributes => [:id, :product, :quantity, :_destroy]
      )
    end

    def set_order
      @order = Order.includes(:details).find(params[:id])
    end
end

class OrdersController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
  end

  def new
    @order_delivery = OrderDelivery.new
  end
  
  def create
    @order_delivery = OrderDelivery.new(order_params)
    if @order_delivery.valid?
    @order_delivery.save
    redirect_to root_path
    else
      render :new
      
    end
  end

  private

  def order_params
    params.permit(:item).merge(user_id: current_user.id)
  end

  # def delivery_params
  #   params.permit(:postal_code, :prefecture, :city, :house_number, :build_number).merge(order_id: @order.id)
  # end
end


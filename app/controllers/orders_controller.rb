class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @item = Item.find(params[:item_id])
    @order_delivery = OrderDelivery.new
      if @item.user_id == current_user.id || @item.order!= nil
        return redirect_to root_path
      end
  end
  
  def create
  #  binding.pry
    @item = Item.find(params[:item_id])
    @order_delivery = OrderDelivery.new(order_params)
    if @order_delivery.valid?
      pay_item
    @order_delivery.save
    redirect_to root_path
    else
      render :index
      
    end
  end

  private

  def order_params
    params.require(:order_delivery).permit(:postal_code, :prefecture_id, :city, :house_number, :build_number, :phone_number).merge(user_id: current_user.id, item_id: params[:item_id], token: params[:token])
  end
   
  def pay_item
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    #Payjp.api_key = "sk_test_f1a2a2ffba1fbe63fe60ced3"  # 自身のPAY.JPテスト秘密鍵を記述しましょう
    Payjp::Charge.create(
      amount: @item.price,  
      card: order_params[:token],    
      currency: 'jpy'             
    )
  end
  # def delivery_params
  #   params.permit(:postal_code, :prefecture, :city, :house_number, :build_number).merge(order_id: @order.id)
  # end
end


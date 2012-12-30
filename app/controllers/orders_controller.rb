class OrdersController < ApplicationController

  def index
    @orders = Order.all
    #@orders = Order.paginate(:page=>params[:page], :order=>'created_at desc', :per_page => 10)
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    if current_cart.line_items.empty?
      redirect_to store_url, :notice => "Your cart is empty"
      return
    end

    @order = Order.new
  end

  def edit
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.new(params[:order])
    @order.add_line_items_from_cart(current_cart)
    if @order.save!
      Cart.destroy(session[:cart_id])
      session[:cart_id] = nil
      Notifier.order_received(@order).deliver
      redirect_to(store_url, :notice => 'Thank you for your order.')
    else
      render action: "new" 
    end
  end
  
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to orders_url 
  end

end

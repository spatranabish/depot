class LineItemsController < ApplicationController
  skip_before_filter :authorize, :only => :create
  
  def index
    @line_items = LineItem.all
  end
  
  def show
    @line_item = LineItem.find(params[:id])
  end
  
  def new
    @line_item = LineItem.new
  end
  
  def edit
    @line_item = LineItem.find(params[:id])
  end
  
  def create
    @cart = current_cart
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)
    respond_to do |format|
      if @line_item.save!
        format.html { redirect_to(store_url) }
        format.js { @current_item = @line_item }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def update
    @line_item = LineItem.find(params[:id])
    if @line_item.update_attributes(params[:line_item])
      redirect_to(@line_item.cart, :notice => 'Line item was successfully updated.')
    else
      render action: "edit"
    end
  end
  
  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy
    redirect_to line_items_url
  end

end

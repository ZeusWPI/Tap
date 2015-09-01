class StocksController < ApplicationController
  load_and_authorize_resource

  def new
    @stock = Stock.new
    Product.all.each do |p|
      @stock.stock_entries << Stock::StockEntry.new(product: p)
    end
  end

  def create
    @stock = Stock.new(params[:stock])
    if @stock.update
      flash[:success] = "Stock updated!"
      redirect_to products_path
    else
      render 'new'
    end
  end
end

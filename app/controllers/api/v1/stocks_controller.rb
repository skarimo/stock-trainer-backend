class Api::V1::StocksController < ApplicationController

  def search_stock
    #find first 10 that includes search term and return
    @search_result = Stock.where("lower(symbol) LIKE ? OR lower(name) LIKE ?", "%#{ search_term["search_term"].downcase }%", "%#{ search_term["search_term"].downcase }%").limit(10)
    render json: @search_result
  end


  private

 def search_term
   params.permit(:stock, :search_term)
 end

end

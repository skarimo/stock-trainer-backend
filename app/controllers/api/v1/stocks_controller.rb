class Api::V1::StocksController < ApplicationController

  def search_stock
    # @search_result = Stock.where("lower(symbol) like ?", "%#{ seach_term.downcase }%")
    @search_result = Stock.all.find_all{|x| x.symbol.downcase.include?(search_term["search_term"].downcase) || x.name.downcase.include?(search_term["search_term"].downcase)}.first(10)
    render json: @search_result
  end

  private

 def search_term
   params.permit(:stock, :search_term)
 end

end

# @news = Article.where(text: "example").order(:created_at).limit(4)

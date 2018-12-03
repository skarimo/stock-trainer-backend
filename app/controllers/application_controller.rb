class ApplicationController < ActionController::API
    before_action :authenticate_request
    attr_reader :current_user

    include ExceptionHandler

    def stock_broadcast(action, stock_card, location)
      if location == "OWNED_STOCK_SHARES"
        @stock_card = OwnedStockShareSerializer.new(OwnedStockShare.find(stock_card.id))
      elsif location == "PURCHASED_STOCKS"
        @stock_card = PurchasedStockSerializer.new(PurchasedStock.find(stock_card.id))
      elsif location == "SOLD_STOCKS"
        @stock_card = SoldStockSerializer.new(SoldStock.find(stock_card.id))
      end

      ActionCable.server.broadcast \
    "stocks_channel_#{stock_card.user.id}", {action: action, stock: @stock_card, location: location}
    end

    def user_balance_broadcast(action, user_id, amount)
      ActionCable.server.broadcast \
    "stocks_channel_#{user_id}", {action: action, account_balance: amount}
    end

    private
    def authenticate_request
      @current_user = AuthorizeApiRequest.call(request.headers).result
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    end
  end

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private
      def find_verified_user
        @user_id = JsonWebToken.decode(request.headers[:HTTP_SEC_WEBSOCKET_PROTOCOL].split(' ').last)["user_id"]
        if verified_user = @user = User.find(@user_id)
          verified_user
        else
          render json: { error: "unauthorized" }, status: :unauthorized
        end
      end
  end
end

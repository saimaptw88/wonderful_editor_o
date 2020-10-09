class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  private

    def sign_up_params
      binding.pry
      params.permit(:name, :email, :password, :password_confirmation)
    end

    def account_update_params
      binding.pry
      params.permit(:name, :email)
    end
end

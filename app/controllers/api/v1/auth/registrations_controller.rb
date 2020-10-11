class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def cresate
    User.create!(sign_up_params)
  end

  private

    def sign_up_params
      params.permit(:name, :email, :password, :password_confirmation)
    end

    def account_update_params
      params.permit(:name, :email)
    end
end

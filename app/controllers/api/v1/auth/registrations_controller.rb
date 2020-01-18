class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def sign_up_params
    params.permit(:name, :email, :password)
  end
end

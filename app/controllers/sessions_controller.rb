class SessionsController < ApplicationController
  def create
    user = User.find_by(email: login_params[:email])

    if user && user.authenticate(login_params[:password])
      session[:user_id] = user.id
      redirect_to "/scripts"
    else
      flash[:msgs] = ["Invalid login credentials"]
      redirect_to "/"
    end

  end

  def destroy
    # delete current user scripts upon logout
    Dir.glob("#{Rails.root}/public/*#{current_user.email}.sh").each { |file| File.delete(file) }
    reset_session
    redirect_to "/"
  end

  private
    def login_params
      params.require(:login).permit(:email, :password)
    end
end

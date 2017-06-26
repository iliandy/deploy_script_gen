class UsersController < ApplicationController
  before_action :user_authorized, only: [:scripts]
  before_action :user_logged_in, only: [:new]

  def new
    @dojos = Dojo.all
    # render "new.html.erb"
  end

  def create
    user = User.create(user_params.merge(dojo: Dojo.find(user_params[:dojo])))

    if user.valid?
      session[:user_id] = user.id
      redirect_to "/scripts"
    else
      flash[:msgs] = user.errors.full_messages
      redirect_to "/"
    end
  end

  def scripts
    @current_user = current_user
    # render "scripts.html.erb"
  end

  # def edit
  #   @current_user = current_user
  #   # render "edit.html.erb"
  # end
  #
  # def update
  #   user = User.update(params[:user_id], user_update_params.merge(state: State.find(user_update_params[:state])))
  #
  #   if user.valid?
  #     flash[:msgs] = ["#{user_update_params[:first_name]} was successfully updated..."]
  #     redirect_to "/scripts"
  #   else
  #     flash[:msgs] = user.errors.full_messages
  #     redirect_to "/users/#{params[:user_id]}/edit"
  #   end
  #
  # end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :dojo)
    end

    # def user_update_params
    #   params.require(:user).permit(:first_name, :last_name, :email, :dojo)
    # end
end

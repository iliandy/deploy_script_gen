class UsersController < ApplicationController
  before_action :user_logged_in, only: [:new]
  before_action :user_authorized, only: [:edit]

  def new
    @dojos = Dojo.all
    # render "new.html.erb"
  end

  def about
  end

  def create
    # admin user registration
    if secret_params[:password] != ''
      key = SecretKey.last
      # valid admin password
      if key and key.authenticate(secret_params[:password])
        user = User.create(user_params.merge(dojo: Dojo.find(user_params[:dojo]), access: true))
        # successful admin user registration
        if user.valid?
          session[:user_id] = user.id
          Admin.create(user: user)
          redirect_to '/scripts'
        # failed admin user registration
        else
          flash[:msgs] = user.errors.full_messages
          redirect_to '/'
        end
      # invalid admin password
      else
        flash[:msgs] = ['Invalid admin password']
        redirect_to '/'
      end
    # student user registration
    else
      user = User.create(user_params.merge(dojo: Dojo.find(user_params[:dojo]), access: false))
      # successful student user registration
      if user.valid?
        session[:user_id] = user.id
        redirect_to '/scripts'
      # failed student user registration
      else
        flash[:msgs] = user.errors.full_messages
        redirect_to '/'
      end
    end
  end

  def destroy
    User.destroy(params[:user_id])
    redirect_to :back
  end

  def edit
    @current_user = current_user
    @dojos = Dojo.all
    # render "edit.html.erb"
  end

  def update
    user = User.update(params[:user_id], user_update_params.merge(dojo: Dojo.find(user_update_params[:dojo])))

    if user.valid?
      flash[:update] = ["#{user_update_params[:first_name]} was successfully updated..."]
    else
      flash[:msgs] = user.errors.full_messages
    end

    redirect_to :back
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :dojo)
    end

    def secret_params
      params.require(:secret_key).permit(:password)
    end

    def user_update_params
      params.require(:user).permit(:first_name, :last_name, :email, :dojo)
    end
end

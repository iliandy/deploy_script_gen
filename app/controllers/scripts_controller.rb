class ScriptsController < ApplicationController
  before_action :user_authorized, only: [:index]

  def index
    @admin_ids = Admin.pluck(:user_id)
    @current_user = current_user
    # render "index.html.erb"
  end

  def generate
    script = Script.new(script_params)

    p script

    if script.valid?
      redirect_to "/admins/#{ current_user.id }"
    else
      flash[:msgs] = script.errors.full_messages
      redirect_to "/scripts"
    end

  end

  private
    def script_params
      params.require(:script).permit(:stack, :project_directory, :github_repo, :server_ip)
    end

end

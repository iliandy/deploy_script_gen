class ScriptsController < ApplicationController
  before_action :user_authorized, only: [:index]

  def str_replace(filepath, search_str, replace_str)
    File.write(f = filepath, File.read(f).gsub(search_str, replace_str))
  end

  def index
    @admin_ids = Admin.pluck(:user_id)
    @current_user = current_user
    # render "index.html.erb"
  end

  def generate
    script = Script.new(script_params)
    p script

    if script.valid?
      require "tempfile"
      require "fileutils"
      scripts_path = "#{Rails.root}/app/assets/scripts"

      temp_file = Tempfile.new("temp_script.sh")

      if script[:stack] == "Python"
        p "Python"
      elsif script[:stack] == "MEAN"
        p "Mean"
      elsif script[:stack] == "Ruby"
        FileUtils.copy_file("#{scripts_path}/ruby_deployment_script.sh", "#{scripts_path}/temp_script.sh")
      end

      str_replace("#{scripts_path}/temp_script.sh", "$project_dir", script[:project_directory])
      str_replace("#{scripts_path}/temp_script.sh", "$url", script[:github_repo])
      str_replace("#{scripts_path}/temp_script.sh", "$ip_addr", script[:server_ip])


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

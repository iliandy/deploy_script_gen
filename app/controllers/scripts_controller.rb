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

    if script.valid?
      require "tempfile"
      require "fileutils"
      scripts_path = "#{Rails.root}/app/assets/scripts"

      if script[:stack] == "MEAN"
        Tempfile.new("MEAN_script_#{current_user.email}.sh")
        temp_script_path = "#{Rails.root}/public/MEAN_script_#{current_user.email}.sh"
        FileUtils.copy_file("#{scripts_path}/mean_deployment_script.sh", temp_script_path)

        str_replace(temp_script_path, "$project_dir", script[:project_directory])
        str_replace(temp_script_path, "$url", script[:github_repo])
        str_replace(temp_script_path, "$ip_addr", script[:server_ip])

      elsif script[:stack] == "Python"
        Tempfile.new("Python_script_#{current_user.email}.sh")
        temp_script_path = "#{Rails.root}/public/Python_script_#{current_user.email}.sh"
        FileUtils.copy_file("#{scripts_path}/python_deployment_script.sh", temp_script_path)

        str_replace(temp_script_path, "$project_dir", script[:project_directory])
        str_replace(temp_script_path, "$app_dir", script[:app_directory])
        str_replace(temp_script_path, "$url", script[:github_repo])
        str_replace(temp_script_path, "$ip_addr", script[:server_ip])

      elsif script[:stack] == "Ruby"
        Tempfile.new("Ruby_script_#{current_user.email}.sh")
        temp_script_path = "#{Rails.root}/public/Ruby_script_#{current_user.email}.sh"
        FileUtils.copy_file("#{scripts_path}/ruby_deployment_script.sh", temp_script_path)

        str_replace(temp_script_path, "$project_dir", script[:project_directory])
        str_replace(temp_script_path, "$url", script[:github_repo])
        str_replace(temp_script_path, "$ip_addr", script[:server_ip])
      end


    else
      flash[:msgs] = script.errors.full_messages
    end

    redirect_to "/scripts"

  end

  private
    def script_params
      params.require(:script).permit(:stack, :project_directory, :app_directory, :github_repo, :server_ip)
    end

end

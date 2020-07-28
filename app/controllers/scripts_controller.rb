class ScriptsController < ApplicationController
  before_action :user_authorized, only: [:index, :download]
  before_action :user_access, only: [:download]

  # writes to specific file by replacing specific search_str with replace_str
  def str_replace(filepath, search_str, replace_str)
    File.write(f = filepath, File.read(f).gsub(search_str, replace_str))
  end

  # writes script template file to replace project directory, github url, and AWS server IP address template placeholders
  def script_replace(temp_script_path, script)
    str_replace(temp_script_path, "$project_dir", script[:project_directory])
    str_replace(temp_script_path, "$url", script[:github_repo])
    str_replace(temp_script_path, "$ip_addr", script[:server_ip])
  end

  def index
    @current_user = current_user
  end

  # core generate method for generating all stack deployment scripts
  # 1. Create new temp script, store in /public dir for downloads
  # 2. Select corresponding deployment script template, copy contents into temp script
  # 3. Replace temp script's project_directory, github_repo, server_ip variables from user form inputs
  def generate
    script = Script.new(script_params)

    if script.valid?
      require "tempfile"
      require "fileutils"
      scripts_path = "#{Rails.root}/app/assets/scripts"

      # MEAN (Angular) script generation
      if script[:stack] == "mean_angular"
        Tempfile.new("MEAN_Angular_#{current_user.email}.sh")
        temp_script_path = "#{Rails.root}/public/MEAN_Angular_#{current_user.email}.sh"
        FileUtils.copy_file("#{scripts_path}/mean_angular_script.sh", temp_script_path)

        script_replace(temp_script_path, script)

      # MEAN (AngularJS) script generation
      elsif script[:stack] == "mean_angularjs"
        Tempfile.new("MEAN_AngularJS_#{current_user.email}.sh")
        temp_script_path = "#{Rails.root}/public/MEAN_AngularJS_#{current_user.email}.sh"
        FileUtils.copy_file("#{scripts_path}/mean_angularjs_script.sh", temp_script_path)

        script_replace(temp_script_path, script)

      # Python Django script generation
      elsif script[:stack] == "python_django"
        Tempfile.new("Python_Django_#{current_user.email}.sh")
        temp_script_path = "#{Rails.root}/public/Python_Django_#{current_user.email}.sh"
        FileUtils.copy_file("#{scripts_path}/python_django_script.sh", temp_script_path)

        script_replace(temp_script_path, script)
        str_replace(temp_script_path, "$app_dir", script[:app_directory])

      # Ruby on Rails script generation
      elsif script[:stack] == "ruby_on_rails"
        Tempfile.new("Ruby_on_Rails_#{current_user.email}.sh")
        temp_script_path = "#{Rails.root}/public/Ruby_on_Rails_#{current_user.email}.sh"
        FileUtils.copy_file("#{scripts_path}/ruby_on_rails_script.sh", temp_script_path)

        script_replace(temp_script_path, script)
      end
      # redirect to download page
      redirect_to "/public"

    else
      flash[:msgs] = script.errors.full_messages
      redirect_to "/scripts"
    end
  end

  # dynamically assigns script variable for download if stack script was generated
  def download
    if File.exist?"#{Rails.root}/public/MEAN_Angular_#{current_user.email}.sh"
      @mean_angular_script = "MEAN_Angular_#{current_user.email}.sh"
    end

    if File.exist?"#{Rails.root}/public/MEAN_AngularJS_#{current_user.email}.sh"
      @mean_angularjs_script = "MEAN_AngularJS_#{current_user.email}.sh"
    end

    if File.exist?"#{Rails.root}/public/Python_Django_#{current_user.email}.sh"
      @python_django_script = "Python_Django_#{current_user.email}.sh"
    end

    if File.exist?"#{Rails.root}/public/Ruby_on_Rails_#{current_user.email}.sh"
      @ruby_on_rails_script = "Ruby_on_Rails_#{current_user.email}.sh"
    end
  end

  private
    def script_params
      params.require(:script).permit(:stack, :project_directory, :app_directory, :github_repo, :server_ip)
    end

end

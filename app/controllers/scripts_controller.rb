class ScriptsController < ApplicationController
  before_action :user_authorized, only: [:index]

  def index
    @admin_ids = Admin.pluck(:user_id)
    @current_user = current_user
    # render "index.html.erb"
  end

  def generate
    


  end

end

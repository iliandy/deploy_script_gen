class AdminsController < ApplicationController
	before_action :user_authorized, only: [:show]
	before_action :instructor_access, only: [:show]
	def show
		@admin = User.find(params[:id])
		@students = User.where(dojo: @admin.dojo).where.not(id:get_admin_ids)
	end
  
	def allow
		user = User.find(params[:id])
		user.update(access: true)
		redirect_to "/admins/#{session[:user_id]}"
	end
  
	def deny
		user = User.find(params[:id])
		user.update(access: false)
		redirect_to "/admins/#{session[:user_id]}"
	end
end

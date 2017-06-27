class AdminsController < ApplicationController
	def show
		@admin = User.find(params[:id])
		admin_ids = Admin.pluck(:user_id)
		@students = User.where(dojo: @admin.dojo).where.not(id:admin_ids)
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

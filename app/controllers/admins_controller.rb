class AdminsController < ApplicationController
	def show
		@admin = User.find(params[:id])
		@students = User.where(dojo: @admin.dojo).where.not(id: params[:id])
	end
end

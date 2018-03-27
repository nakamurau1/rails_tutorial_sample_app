class MicropostsController < ApplicationController
  before_action :_logged_in_user, only: [:create, :destroy]

  def create
  end

  def destroy
  end
end

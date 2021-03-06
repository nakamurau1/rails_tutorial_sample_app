class MicropostsController < ApplicationController
  before_action :_logged_in_user, only: [:create, :destroy]
  before_action :_correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(_micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_back(fallback_location: root_url)
    # redirect_to request.referrer || root_url
  end

  private

  def _micropost_params
    params.require(:micropost).permit(:content, :picture)
  end

  def _correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end

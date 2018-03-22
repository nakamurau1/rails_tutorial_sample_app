class UsersController < ApplicationController
  before_action :_logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :_correct_user,   only: [:edit, :update]
  before_action :_admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
    # @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(_user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(_user_params)
      # 更新に成功した場合を扱う
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  def _user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # ログイン済みユーザーかどうか確認
  def _logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # 正しいユーザーかどうか確認
  def _correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # 管理者かどうか確認
  def _admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end

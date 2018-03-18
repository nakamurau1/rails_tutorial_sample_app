class UsersController < ApplicationController
  before_action :_logged_in_user, only: [:index, :edit, :update]
  before_action :_correct_user,   only: [:edit, :update]

  def index
    @users = User.al
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(_user_params) # 実装は終わっていないことに注意!
    if @user.save
      log_in @user
      flash[:success] = 'Welcome to the Sample App!'
      redirect_to @user
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
end

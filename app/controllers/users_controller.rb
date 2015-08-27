class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      redirect_to root_path
    else
      flash[:alert] = "See errors below"
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.authenticate(params[:user][:current_password])
      if @user.update user_params
        redirect_to edit_users_path, notice: "Profile updated"
      else
        flash[:alert] = "See errors below"
        render :edit
      end
    else
      flash[:alert] = "Wrong password"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email,
                                  :password, :password_confirmation)
  end
end

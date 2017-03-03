class HomeController < ApplicationController
  before_action :authenticate_user!

  def profile
    @user = current_user
  end

  def update
  # PATCH /users/1
  def update
    @user = current_user

    if @user.update_attributes!(params[:user])
      redirect_to profile_path(@user), notice: "User updated!"
      render :proifle, notice: "Your user profile has been updated."
    else
      render :proifle, notice: "There was a problem updating the user."
    end
  end
  end

  # def stuff
  #   @user = current_user
  # end

  # def images
  #   @user = current_user
  # end

  # def shares
  #   @user = current_user
  # end

end

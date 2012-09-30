class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    redirect_to root_url unless current_user.nil?
  	@user = User.new
  end

  def create
    redirect_to root_url unless current_user.nil?
  	@user = User.new(params[:user])
  	if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def edit
    # Ya no hace falta, ya que lo va a obtener el filtro: correct_user
    # @user = User.find(params[:id])
  end

  def update
    # @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Your profile has been updated";
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    u = User.find(params[:id])
    if u.admin?
      redirect_to root_url 
    else
      u.destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    end
  end

  private
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end

  private
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end

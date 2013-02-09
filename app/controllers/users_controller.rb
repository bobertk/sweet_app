class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :index, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

	def create
    redirect_to root_path if signed_in?
      @user = User.new(params[:user])
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user
      else
        render 'new'
      end    
  end

  def destroy
    @user = User.find(params[:id])
    if current_user?(@user)
      flash[:error] = "Don't kill yourself you stupid admin"
      redirect_to root_url and return
    else
      @user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    end
  end

  def new
    if signed_in?
      redirect_to root_url
  	else
      @user = User.new
    end
  end

	def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page] )
  end

  def edit # must be correct_user      
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def update # correct_user
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private    

    def correct_user  
      @user = User.find(params[:id]) # moved from update
      redirect_to(root_path) unless current_user?(@user) # see sessions helper
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end

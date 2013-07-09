class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user, only:[:destroy]
  
  def index
    @users = User.paginate(page: params[:page], :per_page => 7)
  end

  def show
  	@user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
  	  sign_in @user
  	  flash[:success] = "Welcome to the Social App!"
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
    if @user.update_attributes(params[:user])
       flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
     render 'edit'
    end
  end

  def destroy
   User.find(params[:id]).destroy
   flash[:success] = "user deleted!"
   redirect_to user_url 
  end

  private
 
  def signed_in_user  #incase of edit and update denying access unless signed in
    unless signed_in?
     redirect_to signin_url, notice: "Please sign in."
  end
end

 #user being signed in is not enough because he/she can changes someone else data 
 #so we must av the right user to edit/update his/her data   
    def correct_user  
      @user = User.find(params[:id])
      unless current_user?(@user)
      redirect_to root_path, notice: "You can not change someone else profile."
    end
 end

def admin_user
   if !current_user.admin?  #redirect_to(root_path) unless current_user.admin?
   redirect_to root_path
  end
end

end




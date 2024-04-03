class UsersController <ApplicationController 
  def new 
    @user = User.new()
  end 

  def show 
    @user = User.find(params[:id])
  end 

  def create 
    @user = User.new(user_params)
    if @user.save && @user.authenticate(user_params[:password])
      flash[:success] = "Welcome, #{@user.name}!"
      redirect_to user_path(id: @user.id)

    elsif @user.errors[:email].include?("has already been taken")
      flash[:error] = "Email validation error: Email has already been taken"
      redirect_to register_path

    elsif @user.errors[:email].include?("can't be blank")
      flash[:error] = "Email validation error: Email #{@user.errors[:email].to_sentence}"
      redirect_to register_path

    elsif @user.errors[:name].include?("can't be blank")
      flash[:error] = "Name validation error: Name #{@user.errors[:name].to_sentence}"
      redirect_to register_path

    elsif @user.errors[:password].include?("can't be blank")
      flash[:error] = "Password validation error: Password #{@user.errors[:password].to_sentence}"
      redirect_to register_path

    elsif @user.errors[:password_confirmation].include?("doesn't match Password")
      flash[:error] = "Password validation error: Password Confirmation #{@user.errors[:password_confirmation].to_sentence}"
      redirect_to register_path

    else
      flash[:error] = "Validation error occurred. Please check your input."
      redirect_to register_path
    end
  end

  def login_form
    
  end
  
  def login_user
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      cookies.encrypted[:user_id] = @user.id
      cookies.encrypted[:location] = params[:location]
      cookies.encrypted[:expires_at] = 3.days.from_now
      flash[:success] = "Welcome back, #{@user.name}"
 
      redirect_to user_path(@user.id)
    else
      flash[:error] = "Invalid email or password"
      render :login_form
    end
  end
  
  private 

  def user_params 
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end 
end 
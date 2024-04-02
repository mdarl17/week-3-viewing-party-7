class UsersController <ApplicationController 
  def new 
    @user = User.new()
  end 

  def show 
    @user = User.find(params[:id])
  end 

  def create 
    user = User.new(user_params)
    if user.save && user.authenticate(user_params[:password])
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to user_path(id: user.id)
    elsif user.errors[:email].include?("has already been taken")
      flash[:error] = "Email validation error: Email has already been taken"
      redirect_to register_path
    elsif user.errors[:email].include?("can't be blank")
      flash[:error] = "Email validation error: Email has already been taken"
      redirect_to register_path
    elsif user.errors[:name].any?
      flash[:error] = "Name validation error: #{user.errors[:name].to_sentence}"
      redirect_to register_path
    elsif user.errors[:password].any?
      flash[:error] = "password validation error: #{user.errors[:password].to_sentence}"
      redirect_to register_path
    else
      flash[:error] = "Validation error occurred. Please check your input."
      redirect_to register_path
    end
  end

  def login

  end

  private 

  def user_params 
    params.require(:user).permit(:name, :email, :password)
  end 
end 
require 'bcrypt'

class UsersController < ApplicationController

    def register
        @user = User.new
    end

    def create

        @user = User.new
        @user.username = user_params[:username]
        @user.email = user_params[:email]
        @user.password_digest = BCrypt::Password.create(user_params[:password_digest])

        if @user.save
            session[:user_id] = @user.id
            redirect_to '/login'
        else
            render :register
        end
    end

    private

        def user_params
            params.require(:user).permit(:username, :email, :password_digest, :password_digest)
        end
end
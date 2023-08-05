require 'bcrypt'

class UsersController < ApplicationController

    def register
        @user = User.new
    end

    def create

        @user = User.new(user_params)

        if @user.save
            session[:user_id] = @user.id
            redirect_to '/login'
        else
            render :register
        end
    end

    private

        def user_params
            params.require(:user).permit(:username, :email, :password, :password_confirmation)
        end
end
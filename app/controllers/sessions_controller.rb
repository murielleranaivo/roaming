require 'bcrypt'

class SessionsController < ApplicationController

    def login
        @user = User.new
    end

    def create
        #lookup the user in the database
        @user = User.find_by(email: user_params[:email])
        #compare their password
        if @user.authenticate(user_params[:password])
            session[:user_id] = @user.id
            redirect_to '/about'
        else
            flash.now[:notice] ="Invalid password!"
            render :login
        end
    end

    private

        def user_params
            params.require(:user).permit(:email, :password)
        end

    
end
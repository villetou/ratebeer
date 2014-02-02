class SessionsController < ApplicationController
	def new
		#renderoi kirjautumissivu
	end

	def create
		# haetaan usenamea vastaava käyttäjä tietokannasta
		user = User.find_by username: params[:username]

		if user.nil? or not user.authenticate params[:password]
			redirect_to :back, notice: "Username or password do not match!"
		else
			# talletetaan sessioon kirjautuneen käyttäjän id (jos käyttäjä on olemassa)
			session[:user_id] = user.id unless user.nil?
			# uudelleenohjataan käyttäjä omalle sivulleen
			redirect_to user, notice: "Welcome back!"
		end
	end

	def destroy
		#nollataan session
		session[:user_id] = nil
		#uudelleenohjataan käyttäjä pääsivulle
		redirect_to :root
	end
end
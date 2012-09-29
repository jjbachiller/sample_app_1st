module SessionsHelper

	def sign_in(user)
		cookies.permanent[:remember_token] = user.remember_token
		self.current_user = user
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	def signed_in?
		!current_user.nil?
	end

	def current_user=(user)
		@user = user
	end

	def current_user
		# ||= Solo hace la asignación, si @user no está definido. MOLA!
		# Es una especie de operador ternario abreviado.
		# x = x || "valor de x"  <==> x ||= "valor de x"
		@user ||= User.find_by_remember_token(cookies[:remember_token])
	end
end

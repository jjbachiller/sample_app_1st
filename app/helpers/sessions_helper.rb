module SessionsHelper

	def sign_in(user)
		cookies.permanent[:remember_token] = user.remember_token
		self.current_user = user
		# self.current_user = User.find(2)
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	def signed_in?
		# # FIXME!: Ojo esto está mal, por algún motivo al crear un nuevo objecto en el signup, se asigna al curren_user y peta si dejamos solo current_user.nil
		!(current_user.nil?  || current_user.new_record?)
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		# ||= Solo hace la asignación, si @user no está definido. MOLA!
		# Es una especie de operador ternario abreviado.
		# x = x || "valor de x"  <==> x ||= "valor de x"
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
	end

	def current_user?(user)
		current_user == user
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	def store_location
		session[:return_to] = request.url
	end
end

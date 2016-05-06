class Kele
  include 'HTTParty'
  base_uri 'https://www.bloc.io/api/v1'
  def initialize(email, password)
    @auth_user {email: email , password: password}
  end

  def auth_token(options = {})
    options.merge!({basic_auth: @auth_user})
    self.class.post { '/sessions', options}
  end

end

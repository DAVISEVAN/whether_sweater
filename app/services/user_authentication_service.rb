class UserAuthenticationService
  attr_reader :user, :error_messages

  def self.call(email, password)
    new(email, password).call
  end

  def initialize(email, password)
    @user = User.find_by(email: email)
    @password = password
    @error_messages = []
  end

  def call
    if authenticate_user
      self
    else
      @error_messages << 'Invalid credentials'
      self
    end
  end

  def success?
    @error_messages.empty?
  end

  private

  def authenticate_user
    @user && @user.authenticate(@password)
  end
end
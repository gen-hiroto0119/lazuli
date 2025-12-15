class UsersResource < Lazuli::Resource
  def index
    users = UserRepository.all
    Render "users/index", users: users
  end
end

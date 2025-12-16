class UsersResource < Lazuli::Resource
  def index
    users = UserRepository.all
    Render "users/index", users: users
  end

  def create
    user = UserRepository.create(name: params[:name].to_s)

    if turbo_stream?
      return turbo_stream do |t|
        t.append "users_list", fragment: "components/UserRow", props: { user: user }
      end
    end

    redirect_to "/users"
  end
end

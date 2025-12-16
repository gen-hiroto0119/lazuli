module UserRepository
  @users = [
    User.new(id: 1, name: "Alice"),
    User.new(id: 2, name: "Bob")
  ]
  @next_id = 3

  def self.all
    @users
  end

  def self.create(name:)
    user = User.new(id: @next_id, name: name)
    @next_id += 1
    @users << user
    user
  end
end

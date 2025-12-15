module UserRepository
  def self.all
    # Mock data for now
    [
      User.new(id: 1, name: "Alice"),
      User.new(id: 2, name: "Bob")
    ]
  end
end

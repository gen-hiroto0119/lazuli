class TodosResource < Lazuli::Resource
  def index
    todos = [
      { id: 1, text: "Click links to test Turbo navigation", done: false },
      { id: 2, text: "Toggle + delete to confirm Islands hydration", done: false },
    ]

    Render "todos", todos: todos, now: Time.now.to_f
  end
end

require_relative "../repositories/todo_repository"

class TodosResource < Lazuli::Resource
  def index
    todos = TodoRepository.all
    Render "todos", todos: todos, count: todos.length
  end

  def create
    text = params[:text].to_s.strip
    if text.empty?
      return stream_or(redirect_to("/todos")) do |t|
        t.update "flash", "components/FlashMessage", message: "Text is required"
      end
    end

    todo = TodoRepository.create(text: text)

    stream_or(redirect_to("/todos")) do |t|
      t.prepend "todos_list", "components/TodoRow", todo: todo
      t.replace "todos_footer", "components/TodosFooter", count: TodoRepository.count
      t.update "flash", "components/FlashMessage", message: "Added todo ##{todo.id}"
    end
  end

  def update
    todo = TodoRepository.toggle(params[:id])
    unless todo
      return stream_or(redirect_to("/todos")) do |t|
        t.update "flash", "components/FlashMessage", message: "Todo not found: #{params[:id]}"
      end
    end

    stream_or(redirect_to("/todos")) do |t|
      t.replace "todo_#{params[:id]}", "components/TodoRow", todo: todo
      t.update "flash", "components/FlashMessage", message: "Toggled todo ##{params[:id]}"
    end
  end

  def destroy
    if params[:id]
      TodoRepository.delete(params[:id])

      return stream_or(redirect_to("/todos")) do |t|
        t.remove "todo_#{params[:id]}"
        t.replace "todos_footer", "components/TodosFooter", count: TodoRepository.count
        t.update "flash", "components/FlashMessage", message: "Deleted todo ##{params[:id]}"
      end
    end

    # DELETE /todos -> batch delete demo (targets)
    TodoRepository.clear

    stream_or(redirect_to("/todos")) do |t|
      t.remove "#todos_list li"
      t.replace "todos_footer", "components/TodosFooter", count: 0
      t.update "flash", "components/FlashMessage", message: "Deleted all todos via targets"
    end
  end
end

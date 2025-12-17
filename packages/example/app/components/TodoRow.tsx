type Todo = {
  id: number;
  text: string;
  done: boolean;
};

export default function TodoRow(props: { todo: Todo }) {
  const todo = props.todo;

  return (
    <li id={`todo_${todo.id}`} class="flex items-center justify-between gap-3 px-4 py-3">
      <div class="min-w-0 flex-1">
        <div class={todo.done ? "truncate text-slate-400 line-through" : "truncate"}>{todo.text}</div>
      </div>

      <div class="flex shrink-0 items-center gap-2">
        <a
          href={`/todos/${todo.id}`}
          data-turbo-method="patch"
          class="rounded-lg border border-slate-300 bg-white px-2 py-1 text-xs hover:bg-slate-50"
        >
          Toggle
        </a>
        <a
          href={`/todos/${todo.id}`}
          data-turbo-method="delete"
          class="rounded-lg border border-rose-200 bg-rose-50 px-2 py-1 text-xs text-rose-700 hover:bg-rose-100"
        >
          Delete
        </a>
      </div>
    </li>
  );
}

import TodoRow from "../components/TodoRow.tsx";

type Todo = {
  id: number;
  text: string;
  done: boolean;
};

export default function TodosPage(props: { todos: Todo[]; count: number }) {
  return (
    <div class="space-y-4">
      <header class="space-y-1">
        <h1 class="text-xl font-semibold">Todos</h1>
        <p class="text-sm text-slate-600">DB-backed + Turbo Streams (no hooks).</p>
      </header>

      <div id="flash"></div>

      <div class="flex flex-wrap items-center gap-3">
        <form method="post" action="/todos" class="flex flex-1 items-center gap-2">
          <input
            name="text"
            placeholder="Add a todo"
            class="w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm outline-none focus:border-slate-400"
          />
          <button
            type="submit"
            class="rounded-lg bg-slate-900 px-3 py-2 text-sm font-semibold text-white hover:bg-slate-800"
          >
            Add
          </button>
        </form>

        <a
          href="/todos"
          data-turbo-method="delete"
          class="rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm hover:bg-slate-50"
        >
          Delete all
        </a>
      </div>

      <section class="rounded-xl border bg-white">
        <ul id="todos_list" class="divide-y">
          {props.todos.map((todo) => (
            <TodoRow todo={todo} key={todo.id} />
          ))}
        </ul>
      </section>

      <div id="todos_footer" class="text-sm text-slate-600">
        Total todos: {props.count}
      </div>
    </div>
  );
}

import Island from "lazuli/island";
import TodoList from "../components/TodoList.tsx";

type Todo = {
  id: number;
  text: string;
  done: boolean;
};

export default function TodosPage(props: { todos: Todo[]; now: number }) {
  return (
    <div style={{ padding: "12px" }}>
      <h1>Todos (Turbo verification)</h1>
      <p>Server time (props.now): {props.now}</p>

      <div style={{ marginTop: "12px", border: "1px solid #ddd", padding: "12px" }}>
        <h3>Interactive TodoList (Island)</h3>
        <Island path="components/TodoList" component={TodoList} data={{ initialItems: props.todos }} />
      </div>
    </div>
  );
}

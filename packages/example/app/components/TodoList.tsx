"use hydration";

import { useState } from "hono/jsx";

type Todo = {
  id: number;
  text: string;
  done: boolean;
};

export default function TodoList(props: { initialItems: Todo[] }) {
  const [items, setItems] = useState<Todo[]>(props.initialItems);
  const [text, setText] = useState<string>("");

  const nextId = () => (items.reduce((m, i) => Math.max(m, i.id), 0) + 1);

  const add = (e: Event) => {
    e.preventDefault();
    const t = text.trim();
    if (!t) return;

    setItems([...items, { id: nextId(), text: t, done: false }]);
    setText("");
  };

  const toggle = (id: number) => {
    setItems(items.map((i) => (i.id === id ? { ...i, done: !i.done } : i)));
  };

  const remove = (id: number) => {
    setItems(items.filter((i) => i.id !== id));
  };

  return (
    <div>
      <form onSubmit={add} style={{ display: "flex", gap: "8px" }}>
        <input
          value={text}
          onInput={(e) => setText((e.target as HTMLInputElement).value)}
          placeholder="Add a todo"
        />
        <button type="submit">Add</button>
      </form>

      <ul style={{ marginTop: "12px" }}>
        {items.map((t) => (
          <li key={t.id} style={{ display: "flex", gap: "8px", alignItems: "center" }}>
            <label style={{ flex: 1 }}>
              <input type="checkbox" checked={t.done} onChange={() => toggle(t.id)} />{" "}
              <span style={{ textDecoration: t.done ? "line-through" : "none" }}>{t.text}</span>
            </label>
            <button type="button" onClick={() => remove(t.id)}>
              Delete
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}

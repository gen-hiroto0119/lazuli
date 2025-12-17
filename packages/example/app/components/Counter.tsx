"use hydration";

import { useState } from "hono/jsx";

export default function Counter(props: { initialCount: number }) {
  const [count, setCount] = useState(props.initialCount);

  return (
    <button
      type="button"
      onClick={() => setCount(count + 1)}
      class="rounded-lg bg-emerald-600 px-3 py-2 text-sm font-semibold text-white hover:bg-emerald-500"
    >
      Count: {count}
    </button>
  );
}

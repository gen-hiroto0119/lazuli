"use hydration";

import { useState } from "hono/jsx";

export default function Counter(props: { initialCount: number }) {
  const [count, setCount] = useState(props.initialCount);
  
  return (
    <button onClick={() => setCount(count + 1)} class="btn">
      Count: {count}
    </button>
  );
}

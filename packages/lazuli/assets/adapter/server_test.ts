import { assertEquals, assertStringIncludes } from "jsr:@std/assert@^0.224.0";

async function startServer(appRoot?: string) {
  const cwd = Deno.cwd();
  try {
    if (appRoot) Deno.chdir(appRoot);
    const app = await import(`./server.tsx?t=${Date.now()}`);
    const server = Deno.serve({ hostname: "127.0.0.1", port: 0 }, app.default.fetch);
    const addr = server.addr as Deno.NetAddr;
    const baseUrl = `http://127.0.0.1:${addr.port}`;
    return { server, baseUrl };
  } finally {
    Deno.chdir(cwd);
  }
}

Deno.test("render_turbo_stream rejects invalid fragment", async () => {
  const { server, baseUrl } = await startServer();
  try {
    const res = await fetch(`${baseUrl}/render_turbo_stream`, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({
        streams: [{ action: "append", target: "x", fragment: "../secrets", props: {} }],
      }),
    });
    assertEquals(res.status, 400);
    assertStringIncludes(await res.text(), "Turbo Stream render failed");
  } finally {
    await server.shutdown();
  }
});

Deno.test("render_turbo_stream supports targets for remove", async () => {
  const { server, baseUrl } = await startServer();
  try {
    const res = await fetch(`${baseUrl}/render_turbo_stream`, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({
        streams: [{ action: "remove", targets: "#users_list li" }],
      }),
    });

    assertEquals(res.status, 200);
    assertStringIncludes(await res.text(), 'targets="#users_list li"');
  } finally {
    await server.shutdown();
  }
});

Deno.test("render supports basic SSR", async () => {
  const appRoot = await Deno.makeTempDir();
  try {
    await Deno.mkdir(`${appRoot}/app/pages`, { recursive: true });
    await Deno.mkdir(`${appRoot}/app/layouts`, { recursive: true });

    await Deno.writeTextFile(
      `${appRoot}/app/layouts/Application.tsx`,
      `/** @jsxImportSource npm:hono@^4/jsx */
export default function Application(props: { children: unknown }) {
  return <html><head><title>x</title></head><body>{props.children}</body></html>;
}
`,
    );

    await Deno.writeTextFile(
      `${appRoot}/app/pages/home.tsx`,
      `/** @jsxImportSource npm:hono@^4/jsx */
export default function Home(){ return <div>Home</div>; }
`,
    );

    const { server, baseUrl } = await startServer(appRoot);
    try {
      const res = await fetch(`${baseUrl}/render`, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ page: "home", props: {} }),
      });

      assertEquals(res.status, 200);
      const text = await res.text();
      assertStringIncludes(text, "<!DOCTYPE html>");
      assertStringIncludes(text, "Home");
    } finally {
      await server.shutdown();
    }
  } finally {
    await Deno.remove(appRoot, { recursive: true });
  }
});

Deno.test("render injects islands hydration runtime when islands are present", async () => {
  const appRoot = await Deno.makeTempDir();
  try {
    await Deno.mkdir(`${appRoot}/app/pages`, { recursive: true });
    await Deno.mkdir(`${appRoot}/app/layouts`, { recursive: true });
    await Deno.mkdir(`${appRoot}/app/components`, { recursive: true });

    await Deno.writeTextFile(
      `${appRoot}/app/layouts/Application.tsx`,
      `/** @jsxImportSource npm:hono@^4/jsx */
export default function Application(props: { children: unknown }) {
  return <html><head><title>x</title></head><body>{props.children}</body></html>;
}
`,
    );

    await Deno.writeTextFile(
      `${appRoot}/app/components/Widget.tsx`,
      `/** @jsxImportSource npm:hono@^4/jsx */
export default function Widget(props: { name: string }){ return <div>Widget {props.name}</div>; }
`,
    );

    await Deno.writeTextFile(
      `${appRoot}/app/pages/home.tsx`,
      `/** @jsxImportSource npm:hono@^4/jsx */
export default function Home(){
  return (
    <>
      <div data-lazuli-island="/assets/components/Widget.tsx" data-lazuli-props="p1">SSR</div>
      <script id="p1" type="application/json">{"name":"x"}</script>
    </>
  );
}
`,
    );

    const { server, baseUrl } = await startServer(appRoot);
    try {
      const res = await fetch(`${baseUrl}/render`, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ page: "home", props: {} }),
      });

      assertEquals(res.status, 200);
      const text = await res.text();
      assertStringIncludes(text, "data-lazuli-island");
      assertStringIncludes(text, "Lazuli Islands Hydration");
    } finally {
      await server.shutdown();
    }
  } finally {
    await Deno.remove(appRoot, { recursive: true });
  }
});

Deno.test("render auto-wraps a page island when it has \"use hydration\"", async () => {
  const appRoot = await Deno.makeTempDir();
  try {
    await Deno.mkdir(`${appRoot}/app/pages`, { recursive: true });
    await Deno.mkdir(`${appRoot}/app/layouts`, { recursive: true });

    await Deno.writeTextFile(
      `${appRoot}/app/layouts/Application.tsx`,
      `/** @jsxImportSource npm:hono@^4/jsx */
export default function Application(props: { children: unknown }) {
  return <html><head><title>x</title></head><body>{props.children}</body></html>;
}
`,
    );

    await Deno.writeTextFile(
      `${appRoot}/app/pages/home.tsx`,
      `/** @jsxImportSource npm:hono@^4/jsx */
"use hydration";
export default function Home(props: { x: number }){ return <div>Home {props.x}</div>; }
`,
    );

    const { server, baseUrl } = await startServer(appRoot);
    try {
      const res = await fetch(`${baseUrl}/render`, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ page: "home", props: { x: 1 } }),
      });

      assertEquals(res.status, 200);
      const text = await res.text();
      assertStringIncludes(text, 'data-lazuli-island="/assets/pages/home.tsx"');
      assertStringIncludes(text, '"x":1');
      assertStringIncludes(text, "Lazuli Islands Hydration");
    } finally {
      await server.shutdown();
    }
  } finally {
    await Deno.remove(appRoot, { recursive: true });
  }
});

Deno.test("render returns 404 when page is missing", async () => {
  const appRoot = await Deno.makeTempDir();
  try {
    await Deno.mkdir(`${appRoot}/app/layouts`, { recursive: true });
    await Deno.writeTextFile(
      `${appRoot}/app/layouts/Application.tsx`,
      `/** @jsxImportSource npm:hono@^4/jsx */
export default function Application(props: { children: unknown }) {
  return <html><head><title>x</title></head><body>{props.children}</body></html>;
}
`,
    );

    const { server, baseUrl } = await startServer(appRoot);
    try {
      const res = await fetch(`${baseUrl}/render`, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ page: "missing", props: {} }),
      });

      assertEquals(res.status, 404);
      assertStringIncludes(await res.text(), "Render failed (404)");
    } finally {
      await server.shutdown();
    }
  } finally {
    await Deno.remove(appRoot, { recursive: true });
  }
});

import { Hono } from "hono";
import { renderToString } from "solid-js/web";
import { parseArgs } from "@std/cli/parse-args";
import { join, toFileUrl, resolve } from "@std/path";

// Hack to force SolidJS into server mode?
// Or mock DOM for h?
// @ts-ignore
globalThis.window = {};
// @ts-ignore
globalThis.document = {};
// @ts-ignore
globalThis.Element = class {};

// Parse command line arguments
const args = parseArgs(Deno.args, {
  string: ["socket", "app-root"],
  default: {
    "app-root": Deno.cwd(),
  },
});

const app = new Hono();

// RPC Endpoint: Render a page
app.post("/render", async (c) => {
  try {
    const { page, props } = await c.req.json();
    const appRoot = resolve(args["app-root"]);

    // Construct absolute paths for dynamic imports
    const pagePath = join(appRoot, "app", "pages", `${page}.tsx`);
    const layoutPath = join(appRoot, "app", "layouts", "Application.tsx");

    // Import modules
    const PageModule = await import(toFileUrl(pagePath).href);
    const LayoutModule = await import(toFileUrl(layoutPath).href);

    const PageComponent = PageModule.default;
    const LayoutComponent = LayoutModule.default;

    if (!PageComponent) {
      throw new Error(`Page component not found at ${pagePath}`);
    }
    if (!LayoutComponent) {
      throw new Error(`Layout component not found at ${layoutPath}`);
    }

    // Render to string using SolidJS
    const body = renderToString(() => (
      <LayoutComponent>
        <PageComponent {...props} />
      </LayoutComponent>
    ));

    return c.html(`<!DOCTYPE html>${body}`);
  } catch (e) {
    console.error("Render error:", e);
    return c.text(e.toString(), 500);
  }
});

// Asset Server (Placeholder)
app.get("/assets/*", (c) => {
  return c.text("Assets serving not implemented yet", 501);
});

// Start the server
if (args.socket) {
  // Unix Domain Socket
  Deno.serve({
    path: args.socket,
    handler: app.fetch,
    onListen: ({ path }) => {
      console.log(`Lazuli Adapter listening on unix socket: ${path}`);
    }
  });
} else {
  // TCP Fallback (for testing)
  Deno.serve({
    port: 3000,
    handler: app.fetch,
    onListen: ({ port }) => {
      console.log(`Lazuli Adapter listening on http://localhost:${port}`);
    }
  });
}

import { FC } from "hono/jsx";

const Application: FC = (props) => {
  return (
    <html lang="en">
      <head>
        <title>Lazuli Example</title>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1" />

        {/* Example-only: Tailwind via CDN (no build step). */}
        <script src="https://cdn.tailwindcss.com"></script>
      </head>
      <body class="min-h-screen bg-slate-50 text-slate-900">
        <header class="border-b bg-white">
          <div class="mx-auto flex max-w-3xl items-center justify-between gap-4 px-4 py-3">
            <div class="flex items-center gap-4">
              <a href="/" class="font-semibold tracking-tight">
                Lazuli
              </a>
              <nav class="flex items-center gap-3 text-sm">
                <a class="text-slate-700 hover:text-slate-900" href="/">
                  Home
                </a>
                <a class="text-slate-700 hover:text-slate-900" href="/todos">
                  Todos
                </a>
              </nav>
            </div>

            <div class="text-right text-xs text-slate-500">
              <div>
                Boot: <span id="boot-time" class="font-mono"></span>
              </div>
              <div>
                turbo:load: <span id="turbo-load-count" class="font-mono"></span>
              </div>
            </div>
          </div>
        </header>

        <main class="mx-auto max-w-3xl px-4 py-6" id="root">
          {props.children}
        </main>

        <script
          dangerouslySetInnerHTML={{
            __html: `
              window.__lazuliBootTime = window.__lazuliBootTime || Date.now();
              window.__lazuliTurboLoadCount = window.__lazuliTurboLoadCount || 0;

              function renderTurboDebug() {
                var boot = document.getElementById('boot-time');
                var cnt = document.getElementById('turbo-load-count');
                if (boot) boot.textContent = String(window.__lazuliBootTime);
                if (cnt) cnt.textContent = String(window.__lazuliTurboLoadCount);
              }

              document.addEventListener('turbo:load', function () {
                window.__lazuliTurboLoadCount += 1;
                renderTurboDebug();
              });

              renderTurboDebug();
            `,
          }}
        />
      </body>
    </html>
  );
};

export default Application;

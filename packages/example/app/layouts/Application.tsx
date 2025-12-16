import { FC } from "hono/jsx";

const Application: FC = (props) => {
  return (
    <html>
      <head>
        <title>Lazuli Example</title>
        <meta charset="utf-8" />
      </head>
      <body>
        <nav style={{ display: "flex", gap: "12px", padding: "12px", borderBottom: "1px solid #ddd" }}>
          <a href="/">Home</a>
          <a href="/users">Users</a>
          <a href="/todos">Todos</a>
        </nav>

        <div style={{ padding: "12px", borderBottom: "1px solid #eee", fontSize: "12px" }}>
          <div>
            Boot time (persists across Turbo nav): <span id="boot-time"></span>
          </div>
          <div>
            turbo:load count: <span id="turbo-load-count"></span>
          </div>
        </div>

        <div id="root">{props.children}</div>

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

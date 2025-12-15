import { FC } from "hono/jsx";

const Application: FC = (props) => {
  return (
    <html>
      <head>
        <title>Lazuli Example</title>
        <meta charset="utf-8" />
      </head>
      <body>
        <div id="root">{props.children}</div>
      </body>
    </html>
  );
};

export default Application;

import { FC } from "hono/jsx";

const Island: FC<{ path: string; component: any; data: any }> = (props) => {
  const id = "island-" + Math.random().toString(36).slice(2);
  const Component = props.component;
  const propsScriptId = `${id}-props`;
  const jsonProps = JSON.stringify(props.data).replace(/</g, "\\u003c");

  return (
    <>
      <div
        id={id}
        data-lazuli-island={`/assets/${props.path}.tsx`}
        data-lazuli-props={propsScriptId}
      >
        <Component {...props.data} />
      </div>
      <script
        id={propsScriptId}
        type="application/json"
        dangerouslySetInnerHTML={{ __html: jsonProps }}
      />
    </>
  );
};

export default Island;

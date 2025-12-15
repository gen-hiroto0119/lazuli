import { createUniqueId } from "solid-js";
import { ssr } from "solid-js/web";

export default function Island(props: { path: string, component: any, data: any }) {
  const id = createUniqueId();
  const Component = props.component;
  
  // We need to serialize props safely
  const jsonProps = JSON.stringify(props.data);
  
  return (
    <>
      <div id={id}>
        <Component {...props.data} />
      </div>
      <script type="module">{`
        import { hydrate } from "solid-js/web";
        import { createComponent } from "solid-js";
        import Component from "/assets/${props.path}.tsx";
        const el = document.getElementById("${id}");
        hydrate(() => createComponent(Component, ${jsonProps}), el);
      `}</script>
    </>
  );
}

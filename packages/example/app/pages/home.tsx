export default function Home(props: { now: number }) {
  return (
    <div style={{ padding: "12px" }}>
      <h1>Home</h1>
      <p>This page exists to help verify Turbo Drive navigation.</p>
      <p>Server time (props.now): {props.now}</p>
      <p>
        Try: click Users ↔ Todos several times and confirm Boot time stays the same, while turbo:load count increases.
      </p>
    </div>
  );
}

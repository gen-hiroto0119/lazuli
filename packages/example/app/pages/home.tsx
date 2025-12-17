import Counter from "../components/Counter.tsx";
import Island from "lazuli/island";

export default function Home(props: { now: number }) {
  return (
    <div class="space-y-6">
      <section class="rounded-xl border bg-white p-5">
        <h1 class="text-xl font-semibold">Home</h1>
        <p class="mt-2 text-sm text-slate-600">
          Turbo Drive verification page. Navigate Home ↔ Todos and confirm boot time stays the same while turbo:load count
          increases.
        </p>
        <p class="mt-2 text-sm text-slate-600">Server time (props.now): {props.now}</p>
      </section>

      <section class="rounded-xl border bg-white p-5">
        <h2 class="text-base font-semibold">Islands hydration (minimal)</h2>
        <p class="mt-2 text-sm text-slate-600">This component includes a file-top directive: <code>"use hydration"</code>.</p>
        <div class="mt-4">
          <Island path="components/Counter" component={Counter} data={{ initialCount: 10 }} />
        </div>
      </section>
    </div>
  );
}

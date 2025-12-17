export default function FlashMessage(props: { message: string }) {
  return (
    <div class="rounded-xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-800">
      {props.message}
    </div>
  );
}

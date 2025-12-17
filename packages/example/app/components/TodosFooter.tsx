export default function TodosFooter(props: { count: number }) {
  return (
    <div id="todos_footer" class="text-sm text-slate-600">
      Total todos: {props.count}
    </div>
  );
}

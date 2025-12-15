import { For } from "solid-js";

type User = {
  id: number;
  name: string;
};

export default function UsersIndex(props: { users: User[] }) {
  return (
    <div>
      <h1>Users List</h1>
      <ul>
        <For each={props.users}>
          {(user) => (
            <li>
              {user.id}: {user.name}
            </li>
          )}
        </For>
      </ul>
    </div>
  );
}

type User = {
  id: number;
  name: string;
};

export default function UserRow(props: { user: User }) {
  return <li id={`user_${props.user.id}`}>{props.user.id}: {props.user.name}</li>;
}

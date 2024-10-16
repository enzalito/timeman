# Timeman

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix

## Populate the db

```sql
INSERT INTO "users" ("id", "username", "email")
VALUES
  (1, 'John Doe', 'johndoe@example.com'),
  (2, 'James', 'james@example.com'),
  (3, 'Jane Smith', 'janesmith@example.com');

```

```sql
INSERT INTO workingtime (start, "end", "user_id")
VALUES
('2024-10-08 08:00:00', '2024-10-08 12:00:00', 1),
('2024-10-08 14:00:00', '2024-10-08 17:00:00', 1),
('2024-10-09 08:00:00', '2024-10-09 12:00:00', 1),
('2024-10-09 14:00:00', '2024-10-09 17:00:00', 1),

('2024-10-08 07:00:00', '2024-10-08 13:00:00', 3),
('2024-10-08 15:00:00', '2024-10-08 19:00:00', 3);
```

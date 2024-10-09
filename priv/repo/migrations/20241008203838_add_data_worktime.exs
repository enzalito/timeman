defmodule Timeman.Repo.Migrations.AddDataWorktime do
  use Ecto.Migration

  def change do


  execute("""
  INSERT INTO "users" (id, username, email, inserted_at, updated_at)
  VALUES
    (1, 'John Doe', 'johndoe@example.com', NOW(), NOW()),
    (2, 'James', 'james@example.com', NOW(), NOW()),
    (3, 'Jane Smith', 'janesmith@example.com', NOW(), NOW());
  """)


    execute("""
  INSERT INTO workingtime (start, "end", "user", inserted_at, updated_at)
  VALUES
  ('2024-10-08 08:00:00', '2024-10-08 12:00:00', 1, NOW(), NOW()),
  ('2024-10-08 14:00:00', '2024-10-08 17:00:00', 1, NOW(), NOW()),
  ('2024-10-09 08:00:00', '2024-10-09 12:00:00', 1, NOW(), NOW()),
  ('2024-10-09 14:00:00', '2024-10-09 17:00:00', 1, NOW(), NOW()),

  ('2024-10-08 07:00:00', '2024-10-08 13:00:00', 3, NOW(), NOW()),
  ('2024-10-08 15:00:00', '2024-10-08 19:00:00', 3, NOW(), NOW());

  """)

  end
end

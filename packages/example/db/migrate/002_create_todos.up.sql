-- DB-backed todos (Turbo Streams demo)

CREATE TABLE IF NOT EXISTS todos (
  id   INTEGER PRIMARY KEY,
  text TEXT NOT NULL,
  done INTEGER NOT NULL DEFAULT 0
);

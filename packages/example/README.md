# Lazuli Example (e2e)

This app is the acceptance (e2e-ish) sample for Lazuli.

## Prerequisites

- Ruby + Bundler
- Deno

## Setup

```bash
cd packages/example
bundle install

# Create + migrate SQLite DB (db/development.sqlite3)
lazuli db create
```

## Run (dev)

```bash
cd packages/example
lazuli dev --reload
```

Open http://localhost:9292

## Styling (Tailwind)

This example uses Tailwind **via CDN** (see `app/layouts/Application.tsx`) so it has **no build step**.

## E2E smoke (headless)

```bash
cd packages/example
./bin/e2e
```

## Benchmark (local)

Runs a simple built-in HTTP benchmark (no external tools) against the example app.

```bash
cd packages/example
./bin/bench

# knobs
DURATION=10 CONCURRENCY=20 PORT=9294 ./bin/bench
```

## What to verify

### Turbo Drive

- Click `Home` / `Todos`
- "Boot time" should stay the same across navigations
- `turbo:load count` should increase

### Turbo Streams (DB-backed Todos)

Go to `/todos`:

- Create todo: form submit should update the list without full reload
- Toggle: row is replaced via stream
- Delete: row disappears via stream
- Delete all (DELETE /todos): list clears via `targets` selector demo

### Islands hydration (minimal)

Go to `/`:

- Counter works client-side (component has `"use hydration"`)

### DB migrate

- `db/development.sqlite3` should exist
- `schema_migrations` table should include versions `001` and `002`
- `todos` table should exist

require_relative "../structs/todo"

module TodoRepository
  def self.all
    db = Lazuli::Repository.open
    rows = db.execute("SELECT id, text, done FROM todos ORDER BY id DESC")
    rows.map { |r| Todo.new(id: r["id"], text: r["text"].to_s, done: r["done"].to_i == 1) }
  ensure
    db&.close
  end

  def self.count
    db = Lazuli::Repository.open
    row = db.get_first_row("SELECT COUNT(*) AS c FROM todos")
    row ? row["c"].to_i : 0
  ensure
    db&.close
  end

  def self.create(text:)
    t = text.to_s.strip

    db = Lazuli::Repository.open
    db.execute("INSERT INTO todos(text, done) VALUES (?, 0)", t)
    id = db.last_insert_row_id
    Todo.new(id: id, text: t, done: false)
  ensure
    db&.close
  end

  def self.toggle(id)
    db = Lazuli::Repository.open
    db.execute(
      "UPDATE todos SET done = CASE done WHEN 1 THEN 0 ELSE 1 END WHERE id = ?",
      id.to_i
    )
    find(id, db: db)
  ensure
    db&.close
  end

  def self.delete(id)
    db = Lazuli::Repository.open
    db.execute("DELETE FROM todos WHERE id = ?", id.to_i)
  ensure
    db&.close
  end

  def self.clear
    db = Lazuli::Repository.open
    db.execute("DELETE FROM todos")
  ensure
    db&.close
  end

  def self.find(id, db: nil)
    owns = db.nil?
    db ||= Lazuli::Repository.open
    row = db.get_first_row("SELECT id, text, done FROM todos WHERE id = ?", id.to_i)
    return nil unless row

    Todo.new(id: row["id"], text: row["text"].to_s, done: row["done"].to_i == 1)
  ensure
    db&.close if owns
  end
end

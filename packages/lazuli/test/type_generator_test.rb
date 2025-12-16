require "test_helper"
require "lazuli/type_generator"
require "fileutils"

class TypeGeneratorTest < Minitest::Test
  def test_generates_types_for_structs
    Dir.mktmpdir do |dir|
      app_root = File.join(dir, "app_root")
      FileUtils.mkdir_p(File.join(app_root, "app", "structs"))

      File.write(File.join(app_root, "app", "structs", "user.rb"), <<~RUBY)
        class User < Lazuli::Struct
          attribute :id, Integer
          attribute :name, String
          attribute :active, TrueClass
          attribute :score, Float
        end
      RUBY

      out_path = File.join(app_root, "client.d.ts")
      Lazuli::TypeGenerator.generate(app_root: app_root, out_path: out_path)

      content = File.read(out_path)
      assert_includes content, "interface User"
      assert_includes content, "id: number;"
      assert_includes content, "name: string;"
      assert_includes content, "active: boolean;"
      assert_includes content, "score: number;"
    end
  end

  def test_generates_types_for_nested_struct
    Dir.mktmpdir do |dir|
      app_root = File.join(dir, "app_root")
      FileUtils.mkdir_p(File.join(app_root, "app", "structs"))

      File.write(File.join(app_root, "app", "structs", "user.rb"), <<~RUBY)
        class User < Lazuli::Struct
          attribute :id, Integer
          attribute :name, String
        end
      RUBY

      File.write(File.join(app_root, "app", "structs", "post.rb"), <<~RUBY)
        class Post < Lazuli::Struct
          attribute :id, Integer
          attribute :author, User
        end
      RUBY

      out_path = File.join(app_root, "client.d.ts")
      Lazuli::TypeGenerator.generate(app_root: app_root, out_path: out_path)
      content = File.read(out_path)
      assert_includes content, "interface User"
      assert_includes content, "interface Post"
      assert_includes content, "author: User;"
    end
  end

  def test_handles_arrays_and_nullables_and_struct_arrays
    Dir.mktmpdir do |dir|
      app_root = File.join(dir, "app_root")
      FileUtils.mkdir_p(File.join(app_root, "app", "structs"))

      File.write(File.join(app_root, "app", "structs", "user.rb"), <<~RUBY)
        class User < Lazuli::Struct
          attribute :id, Integer
        end
      RUBY

      File.write(File.join(app_root, "app", "structs", "post.rb"), <<~RUBY)
        class Post < Lazuli::Struct
          attribute :tags, [String]
          attribute :maybe_tags, [String, NilClass]
          attribute :authors, [User]
          attribute :maybe_author, [User, NilClass]
        end
      RUBY

      out_path = File.join(app_root, "client.d.ts")
      Lazuli::TypeGenerator.generate(app_root: app_root, out_path: out_path)
      content = File.read(out_path)
      assert_includes content, "tags: string[];"
      assert_includes content, "maybe_tags: string[] | null;"
      assert_includes content, "authors: User[];"
      assert_includes content, "maybe_author: User[] | null;"
    end
  end
end

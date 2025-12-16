require "test_helper"
require "lazuli/cli"
require "fileutils"

class CliNewTest < Minitest::Test
  def test_new_generates_minimal_structure
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        Lazuli::CLI.run(["new", "sample_app"])
        app_root = File.join(dir, "sample_app")

        %w[
          config.ru
          Gemfile
          deno.json
          app/layouts/Application.tsx
          app/pages/home.tsx
          app/resources/home_resource.rb
          tmp/sockets
        ].each do |path|
          assert File.exist?(File.join(app_root, path)), "expected #{path} to exist"
        end

        config = File.read(File.join(app_root, "config.ru"))
        assert_includes config, "Lazuli::App.new"
      end
    end
  end
end

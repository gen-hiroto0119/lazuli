require "test_helper"
require "rack"
require "lazuli/renderer"
require "lazuli/app"

class AppSseTest < Minitest::Test
  def setup
    @tmpdir = Dir.mktmpdir
    @token_path = File.join(@tmpdir, "lazuli_reload_token")
    File.write(@token_path, "token-123")
    ENV["LAZULI_RELOAD_TOKEN_PATH"] = @token_path
    @app = Lazuli::App.new(root: Dir.pwd)
  end

  def teardown
    FileUtils.remove_entry(@tmpdir) if @tmpdir
    ENV.delete("LAZULI_RELOAD_TOKEN_PATH")
  end

  def test_sse_endpoint_returns_event_stream
    status, headers, body = @app.call(Rack::MockRequest.env_for("/__lazuli/events"))
    assert_equal 200, status
    assert_equal "text/event-stream", headers["content-type"]

    first = nil
    body.each do |chunk|
      first = chunk
      break
    end

    assert_includes first, "data: token-123"
  end
end

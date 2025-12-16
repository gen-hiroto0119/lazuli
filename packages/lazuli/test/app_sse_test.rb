require "test_helper"
require "rack"
require "lazuli/renderer"
require "lazuli/app"

class AppSseTest < Minitest::Test
  def setup
    ENV["LAZULI_RELOAD_TOKEN"] = "token-123"
    @app = Lazuli::App.new(root: Dir.pwd)
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

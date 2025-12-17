require "test_helper"
require "rack"
require "lazuli/app"
require "lazuli/resource"
require "lazuli/renderer"
require "lazuli/turbo_stream"

class ImplicitResource < Lazuli::Resource
  def create
    turbo_stream_ops do |t|
      t.prepend "list", fragment: "components/Row", props: { id: 1 }
    end
  end
end

class AppTurboStreamImplicitTest < Minitest::Test
  def setup
    @app = Lazuli::App.new(root: Dir.pwd)
  end

  def test_app_renders_turbo_stream_when_action_returns_turbo_stream
    captured = nil
    original = Lazuli::Renderer.method(:render_turbo_stream)
    Lazuli::Renderer.define_singleton_method(:render_turbo_stream) do |ops|
      captured = ops
      "<turbo-stream></turbo-stream>"
    end

    env = Rack::MockRequest.env_for(
      "/implicit",
      method: "POST",
      "HTTP_ACCEPT" => "text/vnd.turbo-stream.html, text/html"
    )

    status, headers, body = @app.call(env)
    assert_equal 200, status
    assert_equal "text/vnd.turbo-stream.html; charset=utf-8", headers["content-type"]
    assert_equal "accept", headers["vary"]
    assert_includes body.join, "turbo-stream"
    assert_equal :prepend, captured.first[:action]
  ensure
    Lazuli::Renderer.define_singleton_method(:render_turbo_stream, &original)
  end

  def test_app_allows_format_param_for_turbo_stream
    original = Lazuli::Renderer.method(:render_turbo_stream)
    Lazuli::Renderer.define_singleton_method(:render_turbo_stream) { |_ops| "<turbo-stream></turbo-stream>" }

    env = Rack::MockRequest.env_for("/implicit?format=turbo_stream", method: "POST")
    status, headers, _body = @app.call(env)
    assert_equal 200, status
    assert_equal "text/vnd.turbo-stream.html; charset=utf-8", headers["content-type"]
  ensure
    Lazuli::Renderer.define_singleton_method(:render_turbo_stream, &original)
  end

  def test_app_returns_406_when_not_turbo_request
    env = Rack::MockRequest.env_for(
      "/implicit",
      method: "POST",
      "HTTP_ACCEPT" => "text/html"
    )

    status, _headers, _body = @app.call(env)
    assert_equal 406, status
  end
end

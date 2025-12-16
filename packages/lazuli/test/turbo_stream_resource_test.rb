require "test_helper"
require "lazuli/resource"
require "lazuli/renderer"
require "lazuli/turbo_stream"

class TurboStreamResourceTest < Minitest::Test
  class RequestStub
    def initialize(accept)
      @accept = accept
    end

    def get_header(key)
      return @accept if key == "HTTP_ACCEPT"
      nil
    end
  end

  class MyResource < Lazuli::Resource
    def create
      if turbo_stream?
        turbo_stream do |t|
          t.append "list", fragment: "components/Row", props: { id: 1 }
        end
      else
        redirect_to "/"
      end
    end
  end

  def test_turbo_stream_returns_stream_content_type
    original = Lazuli::Renderer.method(:render_turbo_stream)
    Lazuli::Renderer.define_singleton_method(:render_turbo_stream) { |_ops| "<turbo-stream></turbo-stream>" }

    req = RequestStub.new("text/vnd.turbo-stream.html, text/html")
    status, headers, body = MyResource.new({}, request: req).create
    assert_equal 200, status
    assert_equal "text/vnd.turbo-stream.html", headers["content-type"]
    assert_includes body.join, "turbo-stream"
  ensure
    Lazuli::Renderer.define_singleton_method(:render_turbo_stream, &original)
  end
end

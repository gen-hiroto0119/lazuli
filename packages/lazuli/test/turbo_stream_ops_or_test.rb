require "test_helper"
require "lazuli/resource"
require "lazuli/turbo_stream"

class TurboStreamOpsOrTest < Minitest::Test
  class RequestStub
    def initialize(accept)
      @accept = accept
    end

    def get_header(key)
      return @accept if key == "HTTP_ACCEPT"
      nil
    end
  end

  class EmptyRequest
    def get_header(_key)
      nil
    end
  end

  def test_stream_ops_or_returns_turbo_stream_for_turbo_request
    req = RequestStub.new("text/vnd.turbo-stream.html, text/html")
    res = Lazuli::Resource.new({}, request: req).stream_ops_or(:fallback) do |t|
      t.prepend "list", fragment: "components/Row", props: { id: 1 }
    end

    assert_kind_of Lazuli::TurboStream, res
    assert_equal :prepend, res.operations.first[:action]
  end

  def test_stream_ops_or_returns_fallback_for_non_turbo
    res = Lazuli::Resource.new({}, request: EmptyRequest.new).stream_ops_or(:fallback) do |t|
      t.prepend "list", fragment: "components/Row", props: { id: 1 }
    end

    assert_equal :fallback, res
  end

  def test_format_param_enables_stream_ops_or
    res = Lazuli::Resource.new({ format: "turbo_stream" }, request: EmptyRequest.new).stream_ops_or(:fallback) do |t|
      t.prepend "list", fragment: "components/Row", props: { id: 1 }
    end

    assert_kind_of Lazuli::TurboStream, res
  end
end

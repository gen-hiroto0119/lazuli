require "socket"
require "json"
require "net/http"

module Lazuli
  class Error < StandardError; end unless const_defined?(:Error)

  class RendererError < Lazuli::Error
    attr_reader :status, :body

    def initialize(status:, body:, message:)
      @status = status
      @body = body
      super(message)
    end
  end

  class Renderer
    DEFAULT_SOCKET_PATH = File.expand_path(
      ENV["LAZULI_SOCKET"] ||
      File.join(ENV["LAZULI_APP_ROOT"] || Dir.pwd, "tmp", "sockets", "lazuli-renderer.sock")
    )

    def self.render(page, props)
      response = new.post("/render", { page: page, props: props })
      if response[:status] && response[:status] >= 400
        raise Lazuli::RendererError.new(
          status: response[:status],
          body: response[:body],
          message: "Render failed (#{response[:status]}): #{response[:body]}"
        )
      end
      response[:body]
    end

    def self.render_turbo_stream(operations)
      response = new.post("/render_turbo_stream", { streams: operations })
      if response[:status] && response[:status] >= 400
        raise Lazuli::RendererError.new(
          status: response[:status],
          body: response[:body],
          message: "Turbo Stream render failed (#{response[:status]}): #{response[:body]}"
        )
      end
      response[:body]
    end

    def self.asset(path)
      new.get(path)
    end

    def self.configure(socket_path: nil)
      @socket_path = socket_path if socket_path
    end

    def self.socket_path
      @socket_path || DEFAULT_SOCKET_PATH
    end

    def post(path, data)
      request("POST", path, data.to_json)
    end

    def get(path)
      request("GET", path)
    end

    private

    def request(method, path, body = nil)
      begin
        sock = UNIXSocket.new(self.class.socket_path)
        
        req = "#{method} #{path} HTTP/1.1\r\n" \
              "Host: localhost\r\n" \
              "Connection: close\r\n"
        
        if body
          req += "Content-Type: application/json\r\n" \
                 "Content-Length: #{body.bytesize}\r\n"
        end
        
        req += "\r\n"
        req += body if body
        
        sock.write(req)
        
        # Read response
        response = sock.read
        sock.close
        
        headers_raw, body = response.split("\r\n\r\n", 2)
        status = 500
        headers = {}

        if headers_raw
          header_lines = headers_raw.split("\r\n")
          status_line = header_lines.shift
          if status_line && status_line =~ %r{HTTP/\d\.\d\s+(\d+)}
            status = Regexp.last_match(1).to_i
          end
          header_lines.each do |line|
            key, value = line.split(": ", 2)
            headers[key.downcase] = value if key && value
          end
        end

        { status: status, headers: headers, body: body }
      rescue Errno::ENOENT, Errno::ECONNREFUSED
        {
          status: 502,
          headers: {},
          body: "Lazuli Renderer Error: Could not connect to Deno renderer at #{self.class.socket_path}"
        }
      end
    end
  end
end

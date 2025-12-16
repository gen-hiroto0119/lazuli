module Lazuli
  class TurboStream
    attr_reader :operations

    FRAGMENT_PATTERN = %r{\A[a-zA-Z0-9_\-/]+\z}.freeze

    def initialize
      @operations = []
    end

    def append(target = nil, fragment:, props: {}, targets: nil)
      op(:append, target, targets: targets, fragment: fragment, props: props)
    end

    def prepend(target = nil, fragment:, props: {}, targets: nil)
      op(:prepend, target, targets: targets, fragment: fragment, props: props)
    end

    def replace(target = nil, fragment:, props: {}, targets: nil)
      op(:replace, target, targets: targets, fragment: fragment, props: props)
    end

    def update(target = nil, fragment:, props: {}, targets: nil)
      op(:update, target, targets: targets, fragment: fragment, props: props)
    end

    def before(target = nil, fragment:, props: {}, targets: nil)
      op(:before, target, targets: targets, fragment: fragment, props: props)
    end

    def after(target = nil, fragment:, props: {}, targets: nil)
      op(:after, target, targets: targets, fragment: fragment, props: props)
    end

    def remove(target = nil, targets: nil)
      if targets
        @operations << { action: :remove, targets: targets }
      else
        @operations << { action: :remove, target: target }
      end
      nil
    end

    private

    def validate_fragment!(fragment)
      f = fragment.to_s
      raise ArgumentError, "fragment is required" if f.empty?
      raise ArgumentError, "invalid fragment: #{f}" unless f.match?(FRAGMENT_PATTERN)
      raise ArgumentError, "invalid fragment: #{f}" if f.include?("..") || f.start_with?("/")
    end

    def op(action, target, targets:, fragment:, props: {})
      validate_fragment!(fragment)

      op_hash = { action: action, fragment: fragment, props: props }
      if targets
        op_hash[:targets] = targets
      else
        op_hash[:target] = target
      end

      @operations << op_hash
      nil
    end
  end
end

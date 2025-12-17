module Lazuli
  class TurboStream
    attr_reader :operations, :error_target, :error_targets

    FRAGMENT_PATTERN = %r{\A[a-zA-Z0-9_\-/]+\z}.freeze

    def initialize(error_target: nil, error_targets: nil)
      @operations = []
      @error_target = error_target
      @error_targets = error_targets
    end

    def append(target = nil, fragment_arg = nil, fragment: nil, props: {}, targets: nil, **extra_props)
      target, targets = normalize_target_and_targets(target, targets)
      fragment ||= fragment_arg
      props = props.merge(extra_props) unless extra_props.empty?
      op(:append, target, targets: targets, fragment: fragment, props: props)
    end

    def prepend(target = nil, fragment_arg = nil, fragment: nil, props: {}, targets: nil, **extra_props)
      target, targets = normalize_target_and_targets(target, targets)
      fragment ||= fragment_arg
      props = props.merge(extra_props) unless extra_props.empty?
      op(:prepend, target, targets: targets, fragment: fragment, props: props)
    end

    def replace(target = nil, fragment_arg = nil, fragment: nil, props: {}, targets: nil, **extra_props)
      target, targets = normalize_target_and_targets(target, targets)
      fragment ||= fragment_arg
      props = props.merge(extra_props) unless extra_props.empty?
      op(:replace, target, targets: targets, fragment: fragment, props: props)
    end

    def update(target = nil, fragment_arg = nil, fragment: nil, props: {}, targets: nil, **extra_props)
      target, targets = normalize_target_and_targets(target, targets)
      fragment ||= fragment_arg
      props = props.merge(extra_props) unless extra_props.empty?
      op(:update, target, targets: targets, fragment: fragment, props: props)
    end

    def before(target = nil, fragment_arg = nil, fragment: nil, props: {}, targets: nil, **extra_props)
      target, targets = normalize_target_and_targets(target, targets)
      fragment ||= fragment_arg
      props = props.merge(extra_props) unless extra_props.empty?
      op(:before, target, targets: targets, fragment: fragment, props: props)
    end

    def after(target = nil, fragment_arg = nil, fragment: nil, props: {}, targets: nil, **extra_props)
      target, targets = normalize_target_and_targets(target, targets)
      fragment ||= fragment_arg
      props = props.merge(extra_props) unless extra_props.empty?
      op(:after, target, targets: targets, fragment: fragment, props: props)
    end

    def remove(target = nil, targets: nil)
      target, targets = normalize_target_and_targets(target, targets)
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

    def selectorish?(s)
      s.start_with?("#", ".", "[")
    end

    def normalize_target_and_targets(target, targets)
      return [target, targets] if targets
      return [nil, target] if target.is_a?(String) && selectorish?(target)
      [target, nil]
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

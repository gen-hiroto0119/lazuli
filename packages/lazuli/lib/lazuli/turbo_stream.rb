module Lazuli
  class TurboStream
    attr_reader :operations

    def initialize
      @operations = []
    end

    def append(target, fragment:, props: {})
      op(:append, target, fragment: fragment, props: props)
    end

    def prepend(target, fragment:, props: {})
      op(:prepend, target, fragment: fragment, props: props)
    end

    def replace(target, fragment:, props: {})
      op(:replace, target, fragment: fragment, props: props)
    end

    def update(target, fragment:, props: {})
      op(:update, target, fragment: fragment, props: props)
    end

    def remove(target)
      @operations << { action: :remove, target: target }
      nil
    end

    private

    def op(action, target, fragment:, props: {})
      @operations << { action: action, target: target, fragment: fragment, props: props }
      nil
    end
  end
end

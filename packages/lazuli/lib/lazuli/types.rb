# typed: false

module Lazuli
  module Types
    class Union
      attr_reader :types

      def initialize(types)
        @types = types
      end
    end

    class ArrayOf
      attr_reader :type

      def initialize(type)
        @type = type
      end
    end

    class Nilable
      attr_reader :type

      def initialize(type)
        @type = type
      end
    end

    def self.any_of(*types)
      Union.new(types)
    end

    def self.array_of(type)
      ArrayOf.new(type)
    end

    def self.nilable(type)
      Nilable.new(type)
    end
  end
end

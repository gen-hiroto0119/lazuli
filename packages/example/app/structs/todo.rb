class Todo < Lazuli::Struct
  attribute :id, Integer
  attribute :text, String
  attribute :done, Lazuli::Types.any_of(TrueClass, FalseClass)
end

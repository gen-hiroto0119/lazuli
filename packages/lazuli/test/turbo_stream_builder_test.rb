require "test_helper"
require "lazuli/turbo_stream"

class TurboStreamBuilderTest < Minitest::Test
  def test_target_ops_emit_target_only
    t = Lazuli::TurboStream.new

    t.append "a", fragment: "components/Row", props: {}
    t.prepend "b", fragment: "components/Row", props: {}
    t.before "c", fragment: "components/Row", props: {}
    t.after "d", fragment: "components/Row", props: {}
    t.update "e", fragment: "components/Row", props: {}
    t.replace "f", fragment: "components/Row", props: {}
    t.remove "g"

    ops = t.operations

    ops[0..5].each do |op|
      assert op.key?(:target)
      refute op.key?(:targets)
    end

    assert_equal({ action: :remove, target: "g" }, ops[6])
  end

  def test_targets_ops_emit_targets_only
    t = Lazuli::TurboStream.new

    t.append fragment: "components/Row", props: {}, targets: ".row"
    t.prepend fragment: "components/Row", props: {}, targets: ".row"
    t.before fragment: "components/Row", props: {}, targets: ".row"
    t.after fragment: "components/Row", props: {}, targets: ".row"
    t.update fragment: "components/Row", props: {}, targets: ".row"
    t.replace fragment: "components/Row", props: {}, targets: ".row"
    t.remove targets: ".row"

    ops = t.operations

    ops[0..5].each do |op|
      assert op.key?(:targets)
      refute op.key?(:target)
    end

    assert_equal({ action: :remove, targets: ".row" }, ops[6])
  end

  def test_shorthand_accepts_positional_fragment_and_keyword_props
    t = Lazuli::TurboStream.new

    t.append "a", "components/Row", id: 1

    assert_equal(
      { action: :append, target: "a", fragment: "components/Row", props: { id: 1 } },
      t.operations[0]
    )
  end

  def test_selector_shorthand_coerces_first_arg_to_targets
    t = Lazuli::TurboStream.new

    t.update "#flash", "components/Row", id: 1
    t.remove "#users_list li"

    assert_equal(
      { action: :update, targets: "#flash", fragment: "components/Row", props: { id: 1 } },
      t.operations[0]
    )
    assert_equal({ action: :remove, targets: "#users_list li" }, t.operations[1])
  end

  def test_symbol_target_is_coerced_to_string
    t = Lazuli::TurboStream.new

    t.update :flash, "components/Row", id: 1
    t.remove :row_1

    assert_equal(
      { action: :update, target: "flash", fragment: "components/Row", props: { id: 1 } },
      t.operations[0]
    )
    assert_equal({ action: :remove, target: "row_1" }, t.operations[1])
  end

  def test_targets_array_is_joined
    t = Lazuli::TurboStream.new

    t.remove targets: [".row", ".other"]

    assert_equal({ action: :remove, targets: ".row, .other" }, t.operations[0])
  end

  def test_invalid_fragment_is_rejected
    t = Lazuli::TurboStream.new
    assert_raises(ArgumentError) { t.append "a", fragment: "../secrets", props: {} }
  end
end

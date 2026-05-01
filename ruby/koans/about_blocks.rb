require_relative 'koans'

# Topic: Blocks, Procs and Lambdas
# Source: ruby/blocks_procs_lambdas.md

class AboutBlocks < Koans::TestCase
  def double_with_yield(n)
    yield(n)
  end

  def with_or_without_block
    block_given? ? yield : "no block"
  end

  def sum_pair
    yield(1, 2)
  end

  def capture(&blk)
    blk
  end

  def test_block_with_yield
    assert_equal __, double_with_yield(5) { |x| x * 2 }
  end

  def test_block_given
    assert_equal __, with_or_without_block
    assert_equal __, with_or_without_block { "block!" }
  end

  def test_yield_with_multiple_args
    assert_equal __, sum_pair { |a, b| a + b }
  end

  def test_proc_is_an_object
    prc = Proc.new { |x| x * 3 }
    assert_equal __, prc.class
  end

  def test_proc_call
    prc = Proc.new { |x| x + 10 }
    assert_equal __, prc.call(5)
  end

  def test_proc_call_shorthand
    prc = Proc.new { |x| x * 2 }
    assert_equal __, prc.(4)
  end

  def test_lambda_is_an_object
    lam = lambda { |x| x * 2 }
    assert_equal __, lam.class
  end

  def test_lambda_call
    lam = lambda { |x| x + 1 }
    assert_equal __, lam.call(9)
  end

  def test_stabby_lambda
    double = ->(x) { x * 2 }
    assert_equal __, double.call(6)
  end

  def test_lambda_is_lambda
    lam = lambda { }
    prc = Proc.new { }
    assert_equal __, lam.lambda?
    assert_equal __, prc.lambda?
  end

  def test_proc_is_flexible_with_args
    # Proc does not raise an error on wrong arity — missing args become nil
    prc = Proc.new { |x, y| [x, y] }
    assert_equal __, prc.call(1)
  end

  def test_block_to_proc_conversion
    b = capture { |x| x * 5 }
    assert_equal __, b.class
    assert_equal __, b.call(3)
  end

  def test_passing_proc_as_block
    doubler = Proc.new { |x| x * 2 }
    assert_equal __, [1, 2, 3].map(&doubler)
  end
end

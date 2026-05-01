require_relative 'koans'

# Temat: Bloki, Procs i Lambdy
# Dokumentacja: ruby/blocks_procs_lambdas.md

class AboutBlocks < Koans::TestCase
  def test_blok_z_yield
    def podwoj(n)
      yield(n)
    end
    assert_equal __, podwoj(5) { |x| x * 2 }
  end

  def test_block_given
    def z_lub_bez_bloku
      block_given? ? yield : "brak bloku"
    end
    assert_equal __, z_lub_bez_bloku
    assert_equal __, z_lub_bez_bloku { "blok!" }
  end

  def test_yield_z_wieloma_argumentami
    def para
      yield(1, 2)
    end
    assert_equal __, para { |a, b| a + b }
  end

  def test_proc_jest_obiektem
    p = Proc.new { |x| x * 3 }
    assert_equal __, p.class
  end

  def test_proc_call
    p = Proc.new { |x| x + 10 }
    assert_equal __, p.call(5)
  end

  def test_proc_call_skrot
    p = Proc.new { |x| x * 2 }
    assert_equal __, p.(4)
  end

  def test_lambda_jest_obiektem
    lam = lambda { |x| x * 2 }
    assert_equal __, lam.class
  end

  def test_lambda_call
    lam = lambda { |x| x + 1 }
    assert_equal __, lam.call(9)
  end

  def test_stabby_lambda
    podwoj = ->(x) { x * 2 }
    assert_equal __, podwoj.call(6)
  end

  def test_lambda_jest_lambda
    lam = lambda { }
    prc = Proc.new { }
    assert_equal __, lam.lambda?
    assert_equal __, prc.lambda?
  end

  def test_proc_elastyczny_w_argumentach
    # Proc nie rzuca bledu przy blednej liczbie argumentow
    p = Proc.new { |x, y| [x, y] }
    assert_equal __, p.call(1)
  end

  def test_blok_do_proc_konwersja
    def zbierz(&blok)
      blok
    end
    b = zbierz { |x| x * 5 }
    assert_equal __, b.class
    assert_equal __, b.call(3)
  end

  def test_przekazywanie_proc_jako_blok
    podwajacz = Proc.new { |x| x * 2 }
    assert_equal __, [1, 2, 3].map(&podwajacz)
  end
end

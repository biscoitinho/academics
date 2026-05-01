require_relative 'koans'

# Temat: Prawdziwosc i falszywosc w Ruby
# Dokumentacja: ruby/truthiness.md
#
# W Ruby TYLKO nil i false sa falszywe.
# Wszystko inne — lacznie z 0, "" i [] — jest prawdziwe.

class AboutTruthiness < Koans::TestCase
  def test_nil_jest_falszy
    assert_equal __, !!nil
  end

  def test_false_jest_falszy
    assert_equal __, !!false
  end

  def test_zero_jest_prawdziwy
    assert_equal __, !!0
  end

  def test_pusty_string_jest_prawdziwy
    assert_equal __, !!""
  end

  def test_pusta_tablica_jest_prawdziwa
    assert_equal __, !![]
  end

  def test_pusty_hash_jest_prawdziwy
    assert_equal __, !!{}
  end

  def test_nil_is_nil
    assert_equal __, nil.nil?
  end

  def test_zero_nie_jest_nil
    assert_equal __, 0.nil?
  end

  def test_podwojne_zaprzeczenie_zwraca_boolean
    assert_equal __, !!42
    assert_equal __, !!nil
  end

  def test_conditional_assignment
    x = nil
    x ||= "domyslna"
    assert_equal __, x
  end

  def test_conditional_assignment_nie_nadpisuje_wartosci
    x = "juz ustawiona"
    x ||= "domyslna"
    assert_equal __, x
  end

  def test_safe_navigation_na_nil
    # &. nie wywoluje metody gdy obiekt jest nil — zwraca nil
    assert_equal __, nil&.upcase
  end

  def test_safe_navigation_na_wartosci
    assert_equal __, "hello"&.upcase
  end

  def test_unless_jako_odwrotnosc_if
    wynik = unless false
      "wykonano"
    end
    assert_equal __, wynik
  end

  def test_operator_and_and
    assert_equal __, (true && "wartosc")
    assert_equal __, (nil && "wartosc")
  end

  def test_operator_or
    assert_equal __, (nil || "zapasowa")
    assert_equal __, (false || "zapasowa")
    assert_equal __, ("pierwsza" || "zapasowa")
  end
end

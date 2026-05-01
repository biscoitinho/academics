require_relative 'koans'

# Temat: Symbole w Ruby
# Dokumentacja: ruby/symbols.md
#
# Symbole sa niemutowalne, lekkie identyfikatory.
# Ten sam symbol zawsze ma ten sam object_id — sa wspoldzielone w pamieci.

class AboutSymbols < Koans::TestCase
  def test_klasa_symbolu
    assert_equal __, :hello.class
  end

  def test_symbol_na_string
    assert_equal __, :hello.to_s
  end

  def test_string_na_symbol
    assert_equal __, "hello".to_sym
  end

  def test_intern_to_samo_co_to_sym
    assert_equal __, "hello".intern
  end

  def test_symbole_sa_wspoldzielone_w_pamieci
    # Ten sam symbol zawsze ma identyczny object_id
    assert_equal __, :foo.object_id == :foo.object_id
  end

  def test_stringi_nie_sa_wspoldzielone
    # Kazdy nowy string to nowy obiekt
    assert_equal __, "foo".object_id == "foo".object_id
  end

  def test_symbole_sa_niemutowalne
    assert_equal __, :hello.frozen?
  end

  def test_dlugosc_symbolu
    assert_equal __, :hello.length
  end

  def test_upcase_symbolu
    assert_equal __, :hello.upcase
  end

  def test_capitalize_symbolu
    assert_equal __, :ruby.capitalize
  end

  def test_symbol_jako_klucz_hasha
    h = { name: "Alice", age: 30 }
    assert_equal __, h[:name]
  end

  def test_porownanie_symboli
    assert_equal __, :abc == :abc
    assert_equal __, :abc == :def
  end

  def test_symbol_w_case
    status = :aktywny
    wynik = case status
            when :aktywny then "jest aktywny"
            when :nieaktywny then "jest nieaktywny"
            end
    assert_equal __, wynik
  end
end

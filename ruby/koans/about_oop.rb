require_relative 'koans'

# Temat: Programowanie obiektowe w Ruby
# Dokumentacja: ruby/oop_ruby.md

module OOPPrzykladyKlasy
  class Pies
    def initialize(imie)
      @imie = imie
    end

    def imie
      @imie
    end
  end

  class Kot
    attr_accessor :imie
    def initialize(imie)
      @imie = imie
    end
  end

  class Punkt
    attr_reader :x, :y
    def initialize(x, y)
      @x = x
      @y = y
    end
  end

  class Pojazd; end
  class Auto < Pojazd; end

  class Zwierze; end
  class Ptak < Zwierze; end

  class Kalkulator
    def dodaj(a, b)
      a + b
    end
  end

  class Figura
    def opis
      "jestem figura"
    end
  end

  class Kolo < Figura; end

  class Baza
    def powitanie
      "Czesc z bazy"
    end
  end

  class Pochodna < Baza
    def powitanie
      "Czesc z pochodnej"
    end
  end

  class Rodzic
    def przedstaw_sie
      "Jestem rodzicem"
    end
  end

  class Dziecko < Rodzic
    def przedstaw_sie
      super + " i dzieckiem"
    end
  end

  class Licznik
    @@liczba = 0

    def self.resetuj
      @@liczba = 0
    end

    def self.zwieksz
      @@liczba += 1
    end

    def self.wartosc
      @@liczba
    end
  end
end

class AboutOOP < Koans::TestCase
  def test_tworzenie_obiektu
    p = OOPPrzykladyKlasy::Pies.new("Rex")
    assert_equal __, p.imie
  end

  def test_attr_accessor
    k = OOPPrzykladyKlasy::Kot.new("Mruczek")
    assert_equal __, k.imie
    k.imie = "Filemon"
    assert_equal __, k.imie
  end

  def test_attr_reader_tylko_odczyt
    p = OOPPrzykladyKlasy::Punkt.new(3, 4)
    assert_equal __, p.x
    assert_equal __, p.y
  end

  def test_klasa_obiektu
    s = OOPPrzykladyKlasy::Auto.new
    assert_equal __, s.class
  end

  def test_superklasa
    assert_equal __, OOPPrzykladyKlasy::Auto.superclass
  end

  def test_is_a
    p = OOPPrzykladyKlasy::Ptak.new
    assert_equal __, p.is_a?(OOPPrzykladyKlasy::Ptak)
    assert_equal __, p.is_a?(OOPPrzykladyKlasy::Zwierze)
  end

  def test_respond_to
    k = OOPPrzykladyKlasy::Kalkulator.new
    assert_equal __, k.respond_to?(:dodaj)
    assert_equal __, k.respond_to?(:odejmij)
  end

  def test_dziedziczenie_metody
    k = OOPPrzykladyKlasy::Kolo.new
    assert_equal __, k.opis
  end

  def test_nadpisanie_metody
    assert_equal __, OOPPrzykladyKlasy::Pochodna.new.powitanie
    assert_equal __, OOPPrzykladyKlasy::Baza.new.powitanie
  end

  def test_super_wywoluje_metode_rodzica
    assert_equal __, OOPPrzykladyKlasy::Dziecko.new.przedstaw_sie
  end

  def test_metoda_klasowa
    OOPPrzykladyKlasy::Licznik.resetuj
    OOPPrzykladyKlasy::Licznik.zwieksz
    OOPPrzykladyKlasy::Licznik.zwieksz
    assert_equal __, OOPPrzykladyKlasy::Licznik.wartosc
  end
end

require_relative 'koans'

# Temat: Moduly i mixiny
# Dokumentacja: ruby/modules_mixins.md

module Powitalny
  def powitaj
    "Czesc, jestem #{imie}"
  end
end

class OsobaZModulem
  include Powitalny
  attr_reader :imie
  def initialize(imie)
    @imie = imie
  end
end

module Biegacz; end

class Sportowiec
  include Biegacz
end

module Plywak; end

class Zawodnik
  include Plywak
end

module PomocnikKlasowy
  def opis
    "jestem pomocna metoda klasowa"
  end
end

class Narzedzie
  extend PomocnikKlasowy
end

module Geometria
  class Kolo
    def ksztalt
      "kolo"
    end
  end
end

module Matematyka
  PI = 3.14159
end

module Jezdny
  def jedz
    "jade"
  end
end

module Latajacy
  def lec
    "lece"
  end
end

class LatajacySamochod
  include Jezdny
  include Latajacy
end

module M1; end
module M2; end

class BazaZModulami
  include M1
  include M2
end

class AboutModules < Koans::TestCase
  def test_include_dodaje_metody_instancji
    o = OsobaZModulem.new("Alice")
    assert_equal __, o.powitaj
  end

  def test_is_a_z_modulem
    s = Sportowiec.new
    assert_equal __, s.is_a?(Biegacz)
  end

  def test_ancestors_zawiera_modul
    assert_equal __, Zawodnik.ancestors.include?(Plywak)
  end

  def test_extend_dodaje_metody_klasowe
    assert_equal __, Narzedzie.opis
  end

  def test_modul_jako_przestrzen_nazw
    k = Geometria::Kolo.new
    assert_equal __, k.ksztalt
  end

  def test_stala_w_module
    assert_equal __, Matematyka::PI
  end

  def test_wiele_modulow
    ls = LatajacySamochod.new
    assert_equal __, ls.jedz
    assert_equal __, ls.lec
  end

  def test_kolejnosc_ancestors
    # ancestors: [BazaZModulami, M2, M1, Object, ...]
    # ostatni include ma pierwszenstwo w lookup
    assert_equal __, BazaZModulami.ancestors.first
    assert_equal __, BazaZModulami.ancestors[1]
  end

  def test_modul_nie_mozna_instancjonowac
    assert_raise(NoMethodError) { Matematyka.new }
  end
end

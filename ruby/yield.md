# Yield w Ruby

## Problem bez yield

Wyobraź sobie że piszesz metodę która iteruje po tablicy i chcesz coś zrobić z każdym elementem.

Bez yield musiałbyś pisać osobną metodę dla każdego przypadku:

`ruby
def pomnoz_tablice(tablica)
  tablica.map { |n| n * 2 }  # na sztywno * 2
end

def dodaj_do_tablicy(tablica)
  tablica.map { |n| n + 10 }  # na sztywno + 10
end
`

## Z yield - jedna metoda, różne zachowanie

`ruby
def przetworz_tablice(tablica)
  tablica.map { |n| yield n }
end

przetworz_tablice([1,2,3]) { |n| n * 2 }   # [2, 4, 6]
przetworz_tablice([1,2,3]) { |n| n + 10 }  # [11, 12, 13]
przetworz_tablice([1,2,3]) { |n| n  2 }  # [1, 4, 9]
`

Jedna metoda, różne zachowanie w zależności od bloku.

## Realne zastosowania

### 1. Jak działa each, map, select pod spodem

`ruby
def my_each(tablica)
  i = 0
  while i < tablica.length
    yield tablica[i]
    i += 1
  end
end
`

### 2. Otwieranie pliku

`ruby
def otworz_plik(nazwa)
  plik = File.open(nazwa)
  yield plik          # rób co chcesz z plikiem
  plik.close          # zawsze zamknij po
end

otworz_plik("dane.txt") { |f| puts f.read }
`

Gwarantujesz że plik zawsze się zamknie, a użytkownik metody decyduje co z nim zrobi.

### 3. Mierzenie czasu

`ruby
def zmierz_czas
  start = Time.now
  yield
  puts "Zajęło: #{Time.now - start} sekund"
end

zmierz_czas { sleep(2) }
# Zajęło: 2.0 sekund
`

## Główna idea

> yield pozwala oddzielić szkielet operacji od szczegółów implementacji**

Ty piszesz metodę która mówi *"zrób coś przed, zrób coś po"*, a użytkownik metody decyduje co jest w środku.

To się nazywa Template Method pattern i jest bardzo często używane w Ruby.

## Sprawdzenie czy blok został przekazany

`ruby
def bezpieczna_metoda
  if block_given?
    yield
  else
    puts "brak bloku"
  end
end
`

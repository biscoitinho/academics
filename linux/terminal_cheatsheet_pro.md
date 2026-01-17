# 🖥️ Terminal bez myszki --- Rozszerzony Cheatsheet (Markdown Pro)

Elegancki, czytelny i gotowy do użycia w GitHub/VS Code.

------------------------------------------------------------------------

## 🔧 1. Kopiowanie i wklejanie

  Akcja        Skrót Linux            Skrót macOS
  ------------ ---------------------- -------------
  Kopiowanie   **Ctrl + Shift + C**   **Cmd + C**
  Wklejanie    **Ctrl + Shift + V**   **Cmd + V**

------------------------------------------------------------------------

## ⚡ 2. Command Substitution --- używanie wyniku komendy

``` bash
$(komenda)
```

**Przykłady:**

``` bash
du -sh "$(pwd)"
cd "$(dirname "$(which python3)")"
nano "$(find /etc -name fstab)"
```

------------------------------------------------------------------------

## 📦 3. Potoki (pipes)

``` bash
komenda1 | komenda2
```

**Przykłady:**

``` bash
ps aux | grep nginx
ls -la | less
journalctl -xe | grep error
```

------------------------------------------------------------------------

## 📜 4. Historia poleceń

  Skrót          Działanie
  -------------- --------------------------------------
  **Ctrl + R**   wyszukaj w historii
  **!!**         uruchom poprzednie polecenie
  **!\$**        ostatni argument poprzedniej komendy
  **!-2**        polecenie sprzed dwóch

**Przykład:**

``` bash
mkdir test
cd !$
```

------------------------------------------------------------------------

## 📁 5. Nawigacja po katalogach

  Komenda                          Działanie
  -------------------------------- -------------------------------
  `cd ..`                          katalog wyżej
  `cd -`                           poprzedni katalog
  `cd ~/`                          katalog domowy
  `cd "$(find . -type d | fzf)"`   wybór katalogu z wyszukiwarką

------------------------------------------------------------------------

## 📋 6. Schowek bez myszki

### 🔹 X11 (xclip)

``` bash
pwd | xclip -selection clipboard
xclip -selection clipboard -o
```

### 🔹 Wayland (wl-clipboard)

``` bash
pwd | wl-copy
wl-paste
```

------------------------------------------------------------------------

## ⌨️ 7. Edycja linii (Bash / Zsh)

  Skrót             Funkcja
  ----------------- -------------------------------
  **Ctrl + A**      początek linii
  **Ctrl + E**      koniec linii
  **Ctrl + U**      usuń w lewo
  **Ctrl + K**      usuń w prawo
  **Ctrl + W**      usuń słowo
  **Alt + B / F**   wstecz / do przodu o słowo
  **Ctrl + Y**      wklej ostatnio usunięty tekst

------------------------------------------------------------------------

## 📟 8. Podstawowe skróty terminala

  Skrót          Działanie
  -------------- ------------------
  **Ctrl + C**   przerwij proces
  **Ctrl + D**   wyloguj / EOF
  **Ctrl + L**   wyczyść ekran
  **Ctrl + Z**   wstrzymaj proces

------------------------------------------------------------------------

## 🔀 9. Przekierowania

  Operator   Działanie
  ---------- -------------------
  `>`        nadpisz plik
  `>>`       dopisz do pliku
  `<`        input z pliku
  `2>`       błędy do pliku
  `&>`       wszystko do pliku

**Przykłady:**

``` bash
ls -la > lista.txt
echo "test" >> log.txt
cat < config.txt
```

------------------------------------------------------------------------

## 🛠️ 10. Polecane narzędzia CLI

  Narzędzie          Opis
  ------------------ ---------------------
  **fzf**            fuzzy finder
  **ripgrep (rg)**   najszybszy grep
  **bat**            kolorowy cat
  **htop**           procesy
  **ncdu**           miejsce na dysku
  **tmux**           dzielenie terminala

------------------------------------------------------------------------

## 11. Rozmiar pliku/katalogu

  Skrót          Działanie
  -------------- ------------------
  **du -sh /nazwa_katalogu**   pokazuje rozmiar katalogu
  **du -sh nazwa_pliku**   pokazuje rozmiar pliku

Berikut ini adalah langkah-langkah untuk menginstall dan memconfigurasi Alacritty Terminal di Linux Ubuntu:

1. Install dependencies yang dibutuhkan oleh Alacritty dengan menggunakan command berikut pada terminal:
```
sudo apt-get install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev python3
```

2. Install Rust stable yang diperlukan untuk kompilasi menggunakan rustup dengan menggunakan command:

```
curl https://sh.rustup.rs -sSf | sh
```

3. Setelah selesai, buka kembali terminal atau jalankan perintah `. $HOME/.cargo/env` untuk mengaktifkan PATH untuk pengguna saat tersebut.

4. Selanjutnya, download kode sumber Alacritty dengan menggunakan git clone:

```
git clone https://github.com/alacritty/alacritty.git
```

5. Masuk ke direktori alacritty yang baru saja diunduh dengan menjalankan perintah `cd alacritty`.

6. Build dan install Alacritty menggunakan cargo dengan menjalankan perintah:

```
cargo build --release && sudo cp target/release/alacritty /usr/local/bin && sudo cp Alacritty.desktop /usr/share/applications/
```

7. Setelah itu, Alacritty sudah terinstall pada sistem Anda. Gunakan perintah `alacritty` untuk menjalankannya.

8. Bila Anda ingin melakukan konfigurasi pada Alacritty, buat file konfigurasi dengan membuat file `alacritty.yml` pada direktori `$HOME/.config/alacritty/` dan lalu atur sesuai dengan preferensi Anda. Berikut adalah contoh konfigurasi:

```
# colors
colors:
  # Default colors
  primary:
    background: '0x1d1f21'
    foreground: '0xc5c8c6'

  # Vim-like colorscheme for selection with gruvbox palette.
  selection:
    text: '0xffffff'
    background: '0x7c6f64'

  # ANSI colors to use in the terminal emulator
  normal:
    black:   '0x282a2e'
    red:     '0xa54242'
    green:   '0x8c9440'
    yellow:  '0xde935f'
    blue:    '0x5f819d'
    magenta: '0x85678f'
    cyan:    '0x5e8d87'
    white:   '0x707880'

  # Bright variants of the ANSI colors
  bright:
    black:   '0x373b41'
    red:     '0xcc6666'
    green:   '0xb5bd68'
    yellow:  '0xf0c674'
    blue:    '0x81a2be'
    magenta: '0xb294bb'
    cyan:    '0x8abeb7'
    white:   '0xc5c8c6'

# font
font:
  size: 10.0
  family: Consolas


# key mappings
key_bindings:
  # Copy and Paste
  - { key: C,        mods: Control, action: Copy                 }
  - { key: V,        mods: Control, action: Paste                }

```

9. Simpan file konfigurasi tersebut dan jalankan ulang Alacritty untuk mengaktifkan pengaturan baru.

Demikianlah cara install dan konfigurasi Alacritty Terminal di Linux Ubuntu. Semoga dapat membantu!

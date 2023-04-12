## Hyper Terminal Ubuntu
- install Font
```
cd Download
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.0/FiraCode.zip
unzip FiraCode.zip -d ~/.fonts
fc-cache -fv
```
Untuk menginstal dan mengkonfigurasi terminal Hyper di Ubuntu, ikuti langkah-langkah berikut:

**Instalasi:**
1. Buka terminal dengan menekan `Ctrl + Alt + T`.
2. Jalankan perintah berikut untuk men-download paket Hyper `.deb`:
   ```
   wget https://releases.hyper.is/download/deb
   ```
3. Setelah download selesai, jalankan perintah berikut untuk menginstal Hyper:
   ```
   sudo dpkg -i deb
   ```

**Konfigurasi:**
1. Buka Hyper dan arahkan ke `Edit -> Preferences` atau menggunakan shortcut keyboard `Ctrl + ,`.

2. Di jendela preferensi, Anda akan melihat daftar kategori di sisi kiri. Pilih kategori yang ingin Anda konfigurasi (misalnya "Colors").
   - Untuk menambah warna, Anda dapat memilih dari tema yang sudah terpasang atau menginstal tema custom menggunakan paket npm.
   - Untuk mengubah pengaturan lain seperti font, line height, dll., cukup arahkan ke kategori yang relevan di sisi kiri dan ubah pengaturan di panel utama.

3. Setelah melakukan perubahan, tutup jendela preferensi untuk menyimpan perubahan.

Catatan: Jika Anda mengalami masalah selama proses instalasi, pastikan untuk memeriksa versi sistem operasi Ubuntu Anda dan membandingkannya dengan persyaratan versi yang tercantum di [website Hyper](https://hyper.is/#installation).

## dir config
File konfigurasi untuk Hyper di Ubuntu dapat ditemukan di direktori `~/.hyper.js`. 

Untuk membuka file tersebut, Anda dapat menggunakan editor teks seperti Nano atau Vim dengan menjalankan perintah berikut pada terminal:

```
nano ~/.hyper.js          # Menjalankan Nano
vim ~/.hyper.js           # Menjalankan Vim
``` 

Anda juga dapat membuka file tersebut pada editor teks pilihan Anda melalui GUI dengan mengklik kanan file `~/.hyper.js` dan memilih editor teks yang diinginkan.

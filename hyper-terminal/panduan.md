# Berikut adalah langkah-langkah untuk menginstall dan memconfigurasi Hyper Terminal di Linux Ubuntu:
- Pertama-tama, buka terminal pada sistem Anda.
- install Font
```
cd Download
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.0/FiraCode.zip
unzip FiraCode.zip -d ~/.fonts
fc-cache -fv
```
Install Hyper Terminal dengan menggunakan command berikut:

```
sudo apt-get install curl
cd Downloads
curl https://releases.hyper.is/download/deb > hyper.deb
sudo dpkg -i ./hyper.deb
rm ./hyper.deb

```
- Setelah selesai, jalankan hyper pada terminal atau dapat juga dijalankan melalui menu aplikasi.
- Sekarang mari kita konfigurasi tampilan dan preferensi Hyper Terminal.
- Buka file konfigurasi pada direktori $HOME/.hyper.js dengan menggunakan editor teks favorit Anda.
- ganti confurasi 

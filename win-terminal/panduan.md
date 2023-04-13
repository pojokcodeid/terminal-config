To install `PSReadLine` module in PowerShell, you can use the following command:

```powershell
Install-Module -Name PSReadLine -Scope CurrentUser
```

This command will install the latest version of the `PSReadLine` module for the current user.

Note: Before running this command, make sure you have an internet connection and the execution policy set to allow script execution.

## INstall Icon

Untuk menginstall terminal-icons pada PowerShell, ikuti langkah-langkah berikut:

1. Pastikan Anda memiliki module package manager `PowerShellGet` dan `PackageManagement`. Jika belum, jalankan perintah berikut untuk menginstallnya:

   ```powershell
   Install-Module -Name PowerShellGet -Force
   Install-Module -Name PackageManagement -Force
   ```

2. Setelah itu, install module `Terminal-Icons` dengan menjalankan perintah ini :

   ```powershell
   Install-Module -Name Terminal-Icons
   ```

3. Tunggu sampai proses instalasi selesai dan konfirmasi jika diminta.

4. Setelah module di-install, jalankan perintah berikut untuk menambahkan baris kode ke `$PROFILE`: 

   ```powershell
   Add-Content $PROFILE "`nImport-Module Terminal-Icons"
   ```

5. Mulai ulang PowerShell atau jalankan perintah berikut agar perubahan yang diterapkan:

   ```powershell
   . $PROFILE
   ```

Sekarang, terminal-icons sudah terpasang pada PowerShell dan dapat digunakan untuk menampilkan icon pada direktori atau file dalam terminal.
  
 ## edit Profile 
 notepad $profile
- copy config dari config powershell

Untuk menjalankan file PowerShell script (.ps1) di Windows, Anda dapat mengikuti langkah-langkah berikut:

Melalui PowerShell
Buka PowerShell:

Buka Start Menu.
Cari "PowerShell" dan buka aplikasi "Windows PowerShell" atau "Windows PowerShell ISE".
Izinkan Eksekusi Skrip:

Pastikan kebijakan eksekusi PowerShell memungkinkan skrip dieksekusi. Jika perlu, jalankan perintah berikut di PowerShell dengan izin administrator:
powershell
Copy code
Set-ExecutionPolicy RemoteSigned
Jalankan Skrip:

Gunakan perintah Set-Location untuk menuju ke direktori yang berisi skrip PowerShell jika diperlukan:
powershell
Copy code
Set-Location "C:\path\to\your\script\folder"
Jalankan skrip dengan perintah .\nama_skrip.ps1 (menggantikan nama_skrip dengan nama file skrip Anda):
powershell
Copy code
.\nama_skrip.ps1
Melalui Task Scheduler

# Backup File Server dengan powershell dan PuTTY Private Key Files


## Menjalankan File PowerShell Script (.ps1) di Windows

### Melalui PowerShell

1. **Buka PowerShell:**
    - Buka Start Menu.
    - Cari "PowerShell" dan buka aplikasi "Windows PowerShell" atau "Windows PowerShell ISE".

2. **Izinkan Eksekusi Skrip:**
    Pastikan kebijakan eksekusi PowerShell memungkinkan skrip dieksekusi. Jika perlu, jalankan perintah berikut di PowerShell dengan izin administrator:
    ```powershell
    Set-ExecutionPolicy RemoteSigned
    ```

3. **Jalankan Skrip:**
    - Gunakan perintah `Set-Location` untuk menuju ke direktori yang berisi skrip PowerShell jika diperlukan:
    ```powershell
    Set-Location "C:\path\to\your\script\folder"
    ```
    - Jalankan skrip dengan perintah `.\<nama_skrip>.ps1` (gantikan `<nama_skrip>` dengan nama file skrip Anda):
    ```powershell
    .\nama_skrip.ps1
    ```

### Melalui Task Scheduler

1. **Buka Task Scheduler:**
    - Buka "Task Scheduler" dari Start Menu atau jalankan `taskschd.msc` dari Run (Win + R).

2. **Buat Tugas Baru:**
    - Klik kanan di "Task Scheduler Library" dan pilih "Create Task...".

3. **Konfigurasi Tugas:**
    - Beri tugas nama yang deskriptif di tab "General".
    - Pilih tab "Actions", klik "New...", dan pilih aksi "Start a program".
    - Isi "Program/script" dengan jalur ke `powershell.exe` (biasanya `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`).
    - Di bagian "Add arguments (optional)", tambahkan argumen `-File "C:\path\to\your\script\folder\nama_skrip.ps1"` (gantikan dengan path skrip Anda).

4. **Atur Waktu Eksekusi:**
    - Pilih tab "Triggers", klik "New...", dan atur jadwal eksekusi sesuai kebutuhan.

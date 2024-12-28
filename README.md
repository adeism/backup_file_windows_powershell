# 📁 Server to Local Sync

Automatisasikan proses sinkronisasi file antara server Ubuntu dan komputer lokal Windows dengan skrip PowerShell ini. Gunakan skrip ini untuk menyalin file secara rekursif, menjaga atribut file, dan mencatat aktivitas untuk pemantauan yang lebih baik.

## 🚀 Fitur

- 🔐 **Autentikasi Aman:** Menggunakan kunci PPK untuk autentikasi SSH.
- 🔄 **Sinkronisasi Rekursif:** Menyalin seluruh direktori dan subdirektori.
- 🕒 **Preservasi Atribut File:** Menjaga timestamp dan atribut lainnya.
- 📜 **Logging Otomatis:** Mencatat aktivitas dan kesalahan ke file log.
- 🛠️ **Konfigurasi Mudah:** Ganti variabel konfigurasi sesuai kebutuhan Anda.

## 📝 Prasyarat

Sebelum menjalankan skrip, pastikan Anda memiliki hal-hal berikut:

- **Windows PowerShell:** Versi terbaru PowerShell terinstal di sistem Anda.
- **PuTTY & pscp:** Alat pscp.exe dari PuTTY untuk transfer file SCP.
- **Kunci PPK:** File kunci PPK untuk autentikasi SSH.
- **Akses SSH:** Akses ke server Ubuntu dengan kredensial yang benar.

## 📥 Instalasi

1. **Clone Repositori:**

    ```bash
    git clone https://github.com/username/repo-name.git
    ```

2. **Instal PuTTY:**

    Unduh dan instal [PuTTY](https://www.putty.org/) untuk mendapatkan `pscp.exe`.

3. **Tempatkan pscp.exe:**

    Pastikan `pscp.exe` berada di jalur yang sesuai, misalnya `C:\Program Files\PuTTY\pscp.exe`.

## ⚙️ Konfigurasi

Buka skrip PowerShell dan sesuaikan variabel konfigurasi di bagian **Configuration Variables**:

```powershell
# =============================
# Configuration Variables
# =============================

# Path to the source folder on the Ubuntu server
$serverFolder = '/path/to/source/folder/'

# Path to the local destination folder on Windows
$localFolder = 'D:\Path\To\Local\Destination'

# Path to the PPK key file for authentication
$ppkFilePath = 'C:\Path\To\Your\keyfile.ppk'

# Ubuntu server credentials
$username = 'your_username'                  # Your server username
$serverIP = 'your.server.ip.address'         # Your server's IP address

# Path to the pscp executable
$pscpPath = 'C:\Path\To\PuTTY\pscp.exe'

# Log file path (optional)
$logFile = 'D:\Path\To\Log\copy_log.txt'

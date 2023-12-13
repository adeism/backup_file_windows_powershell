# Variabel untuk path folder server di Ubuntu
$serverFolder = '/path/to/server/folder'

# Variabel untuk path folder tujuan di komputer lokal
$localFolder = 'D:\Project\tes'

# Variabel untuk path ke file kunci PPK
$ppkFilePath = 'D:\Project\ppk\root_151_fmpc.ppk'

# Variabel untuk username pada server Ubuntu
$username = 'your_username'

# Variabel untuk alamat IP server Ubuntu
$serverIP = 'server_IP_address'

# Buat perintah pscp untuk menyalin file dari server ke komputer lokal
$command = "& 'C:\Program Files\PuTTY\pscp.exe' -i `"$ppkFilePath`" `${username}@${serverIP}:`"$serverFolder/*`" `"$localFolder`""

# Jalankan perintah pscp
Invoke-Expression -Command $command

# Cek apakah folder tujuan di komputer lokal ada
if (-not (Test-Path -Path $localFolder)) {
    Write-Host "Folder tujuan tidak ditemukan."
} else {
    # Ambil semua file yang baru disalin ke komputer lokal
    $copiedFiles = Get-ChildItem -Path $localFolder

    # Ambil semua file yang ada di folder server
    $serverFiles = Get-ChildItem -Path $serverFolder

    # Loop untuk setiap file di folder server
    foreach ($file in $serverFiles) {
        $localFilePath = Join-Path -Path $localFolder -ChildPath $file.Name

        # Periksa apakah file sudah ada di komputer lokal
        if ($copiedFiles.Name -contains $file.Name) {
            # Bandingkan waktu modifikasi file di server dan komputer lokal
            $localFile = Get-Item $localFilePath
            if ($file.LastWriteTime -gt $localFile.LastWriteTime) {
                # Jika file di server lebih baru, ganti file lama dengan yang baru
                Copy-Item -Path $file.FullName -Destination $localFilePath -Force
                Write-Host "File $file.Name diperbarui."
            }
        } else {
            # Jika file belum ada di komputer lokal, salin file dari server
            Copy-Item -Path $file.FullName -Destination $localFolder -Force
            Write-Host "File $file.Name disalin ke komputer lokal."
        }
    }
}

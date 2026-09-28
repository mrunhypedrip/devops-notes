# Dokumentasi Setup Environment WSL2 (openSUSE Leap 16.0)

- **Tanggal:** 28 September 2026
- **Author:** unhypedrip (mrunhypedrip@gmail.com)

## Konteks Real-World
Dalam operasional DevOps modern, *container engine* (Docker/Podman), *local Kubernetes cluster* (kind/k3d), dan berbagai *system services* membutuhkan `systemd` sebagai PID 1 (*init process*). Tanpa `systemd`, ekosistem *cloud-native* tidak dapat berjalan secara native di lingkungan WSL2.

## Konsep
WSL2 secara default menginisialisasi sistem menggunakan *custom init process* buatan Microsoft. Dengan mengisikan `systemd=true` pada `/etc/wsl.conf`, kernel WSL2 menyerahkan proses inisialisasi utama ke `systemd`.

## Langkah Lengkap

### 1. Mengaktifkan systemd di WSL2
```bash
echo -e "[boot]\nsystemd=true" | sudo tee /etc/wsl.conf
```
*(Lakukan `wsl.exe --shutdown` di PowerShell untuk me-restart WSL).*

### 2. Konfigurasi Alokasi Resource (.wslconfig)
Dibuat di `%USERPROFILE%\.wslconfig` (Windows):
```ini
[wsl2]
memory=10GB
processors=8
swap=4GB
```

### 3. Masking Service Degraded (audit-rules)
`audit-rules.service` tidak didukung penuh oleh kernel modifikasi WSL2, sehingga di-masking agar status `systemd` kembali sehat:
```bash
sudo systemctl mask audit-rules.service
sudo systemctl reset-failed
```

### 4. Konfigurasi Default User (/etc/wsl.conf)
Agar WSL2 otomatis masuk ke user `underground`, bukan `root`:
```bash
echo -e "\n[user]\ndefault=underground" | sudo tee -a /etc/wsl.conf
```

### 5. Setup Git Global & SSH Key GitHub
```bash
git config --global user.name "unhypedrip"
git config --global user.email "mrunhypedrip@gmail.com"
ssh-keygen -t ed25519 -C "mrunhypedrip@gmail.com"
cat ~/.ssh/id_ed25519.pub
```

## Verifikasi & Output
```bash
# Cek PID 1
ps --no-headers -o comm 1
# Expected output: systemd

# Cek status systemd
systemctl is-system-running
# Expected output: running

# Cek Resource Limit
free -h
nproc
# Expected output: ~9.7 GiB RAM, 8 processors

# Cek Koneksi SSH GitHub
ssh -T git@github.com
# Expected output: Hi mrunhypedrip! You've successfully authenticated...
```

## Troubleshooting
- **Masalah:** MobaXterm Connection Refused / Bug WSL Session saat `systemd` aktif.
- **Penyebab:** MobaXterm WSL tab mencoba membuka koneksi SSH/socket bawaan yang gagal berinteraksi dengan proses boot `systemd`.
- **Solusi:** Gunakan Local Terminal MobaXterm (PowerShell/Cmd) dan panggil WSL secara langsung dengan command:
  `wsl -d openSUSE-Leap-16.0 -u underground`

## Catatan Spesifik openSUSE Leap 16.0 & WSL2
- Package manager yang digunakan adalah `zypper` (bukan `apt` atau `dnf`).
- Peringatan `firewalld: command not found` aman diabaikan karena image dasar WSL openSUSE Leap 16.0 belum menyertakan `firewalld` secara default.

## Cheat Sheet Commands
- `wsl.exe --shutdown` : Mematikan seluruh instance WSL2 dari Windows.
- `systemctl is-system-running` : Cek kesehatan systemd.
- `systemctl --failed` : Melihat service yang gagal running.
- `sudo systemctl mask <service>` : Mematikan service secara permanen.
- `ssh -T git@github.com` : Menguji autentikasi SSH ke GitHub.

## Referensi
- [Microsoft Docs - WSL Systemd Support](https://learn.microsoft.com/en-us/windows/wsl/systemd)
- [openSUSE Leap Documentation](https://doc.opensuse.org/)

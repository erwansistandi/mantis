# 🐞 MantisBT Dockerized

Docker Compose setup for running [Mantis Bug Tracker (MantisBT)](https://www.mantisbt.org/) with MySQL.

## 📦 Fitur

- Menggunakan custom image: [`erwanku/mantisbt-alpine:v.2.26.2`](https://hub.docker.com/r/erwanku/mantisbt-alpine)
- Database menggunakan `MySQL 5.7`
- Volume persistensi untuk data database
- Konfigurasi bisa disesuaikan melalui `config_inc.php`

## 🚀 Cara Menjalankan

1. Clone repositori ini
```bash
git clone https://github.com/erwansistandi/mantis.git
cd mantis
2. Sesuaikan konfigurasi (opsional)
Edit file config/config_inc.php sesuai kebutuhan kamu.
3. Jalankan container
docker-compose up -d
4. Akses Aplikasi
Buka browser dan akses: http://localhost:8989
🛠 Default Credential
| Field   | Value                |
| ------- | -------------------- |
| DB User | mantis               |
| DB Pass | mantis               |
| DB Name | mantis               |
| DB Host | db (dalam container) |

🐳 Image Docker
Image tersedia di Docker Hub:

👉 erwanku/mantisbt-alpine

🤝 Kontribusi
Pull request, issue, atau saran sangat diterima! Jangan lupa ⭐ repo ini kalau membantu kamu!






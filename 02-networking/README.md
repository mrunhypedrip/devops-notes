
Modul 02: Production Network & SSL Diagnostics
1. Konsep & Industri Utility
Monitoring latensi DNS dan masa aktif sertifikat SSL/TLS secara otomatis untuk mencegah downtime aplikasi publik.

2. Topologi Alur Diagnostics
Code snippet
graph TD
    Domain[Target Domain] --> DNS[DNS Latency Check]
    DNS --> SSL[SSL Certificate Expiry Check]
    SSL --> HTTP[HTTP Endpoint Health Check]
3. Komponen Utama
production_net_diag.sh : Script penguji DNS latency, SSL Expiry, & HTTP Status Code.

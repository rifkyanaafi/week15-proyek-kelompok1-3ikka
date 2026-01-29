# User Guide - Agri-POS

**Versi:** 1.0  
**Aplikasi:** Agri-POS (Sistem Point of Sale untuk Produk Pertanian)  
**Platform:** Desktop (Windows/Linux/Mac)

---

## 1. Pendahuluan

### 1.1 Tentang Agri-POS

Agri-POS adalah aplikasi kasir digital yang dirancang khusus untuk toko produk pertanian. Aplikasi ini membantu:
- **Kasir** untuk melakukan transaksi penjualan dengan cepat dan mudah
- **Admin** untuk mengelola produk dan melihat laporan penjualan

### 1.2 Fitur Utama
- ✅ Login berdasarkan role (Admin/Kasir)
- ✅ Manajemen produk (CRUD)
- ✅ Transaksi penjualan dengan keranjang belanja
- ✅ Pembayaran Tunai dan E-Wallet
- ✅ Struk digital
- ✅ Laporan penjualan harian

---

## 2. Memulai Aplikasi

### 2.1 Menjalankan Aplikasi

**Langkah:**
1. Pastikan database PostgreSQL sudah berjalan
2. Buka terminal/command prompt
3. Jalankan perintah:
   ```bash
   mvn javafx:run
   ```
4. Aplikasi akan terbuka dengan halaman Login

### 2.2 Login ke Sistem

![Login Screen](../screenshots/login.png)

**Langkah:**
1. Masukkan **Username**
2. Masukkan **Password**
3. Klik tombol **"Login"**

**Kredensial Default:**

| Username | Password | Role |
|----------|----------|------|
| admin | admin123 | Admin |
| kasir1 | kasir123 | Kasir |
| kasir2 | kasir123 | Kasir |

**Hasil:**
- Jika role **Admin** → Masuk ke Dashboard Admin
- Jika role **Kasir** → Masuk ke Point of Sale (POS)
- Jika kredensial salah → Muncul pesan error

---

## 3. Panduan untuk ADMIN

### 3.1 Dashboard Admin

![Admin Dashboard](../screenshots/admin_dashboard.png)

Dashboard Admin terdiri dari:
- **Tabel Produk**: Menampilkan semua produk
- **Form Produk**: Untuk tambah/edit produk
- **Tombol Aksi**: Simpan, Update, Hapus
- **Laporan**: Tombol untuk melihat omzet

---

### 3.2 Menambah Produk Baru

**Langkah:**
1. Isi form di bagian bawah/samping tabel:
   - **Kode**: Kode unik produk (contoh: AGR010)
   - **Nama**: Nama produk (contoh: Pupuk Organik)
   - **Kategori**: Kategori produk (contoh: Pupuk)
   - **Harga**: Harga satuan (contoh: 50000)
   - **Stok**: Jumlah stok (contoh: 100)
2. Klik tombol **"Simpan"**
3. Produk akan muncul di tabel

**Tips:**
- ✅ Kode harus unik (tidak boleh duplikat)
- ✅ Harga dan stok harus angka positif
- ✅ Jika ada error, periksa console untuk detail

---

### 3.3 Mengubah Data Produk

**Langkah:**
1. Klik/pilih produk yang ingin diubah dari tabel
2. Data produk akan muncul di form
3. Edit field yang ingin diubah
4. Klik tombol **"Update"**
5. Perubahan akan tersimpan

**Catatan:**
- Kode produk tidak bisa diubah (Primary Key)

---

### 3.4 Menghapus Produk

**Langkah:**
1. Pilih produk yang ingin dihapus dari tabel
2. Klik tombol **"Hapus"**
3. Produk akan dihapus dari database dan tabel

**Peringatan:**
- ⚠️ Hapus data bersifat permanen
- ⚠️ Jika produk sudah pernah dijual (ada di transaksi), sebaiknya tidak dihapus

---

### 3.5 Melihat Laporan Penjualan

**Langkah:**
1. Klik tombol **"Lihat Laporan"** atau **"Report"**
2. Sistem akan menampilkan total omzet harian
3. Format: **Rp XXX,XXX**

**Informasi Laporan:**
- Total penjualan hari ini (dari tabel `transactions`)
- Update real-time setiap ada transaksi baru

---

### 3.6 Logout

**Langkah:**
1. Klik tombol **"Logout"** di pojok atas/bawah
2. Aplikasi akan kembali ke halaman Login

---

## 4. Panduan untuk KASIR

### 4.1 Dashboard POS (Point of Sale)

![POS Dashboard](../screenshots/pos_dashboard.png)

Dashboard POS terdiri dari:
- **Katalog Produk** (kiri): Daftar semua produk
- **Search Box**: Untuk mencari produk
- **Keranjang Belanja** (kanan): Produk yang akan dibeli
- **Total Belanja**: Total harga
- **Tombol Checkout**: Untuk proses pembayaran

---

### 4.2 Mencari Produk

**Langkah:**
1. Ketik nama atau kode produk di **Search Box**
2. Tabel katalog akan otomatis ter-filter
3. Pencarian case-insensitive (PUPUK = pupuk)

**Tips:**
- Ketik sebagian nama (contoh: "pupuk" untuk cari semua pupuk)
- Clear search box untuk melihat semua produk

---

### 4.3 Menambah Produk ke Keranjang

**Cara 1: Double-Click**
1. Double-click produk di tabel katalog
2. Produk otomatis masuk ke keranjang dengan qty = 1

**Cara 2: Manual Input**
1. Isi field **Kode Produk**
2. Isi field **Qty** (jumlah)
3. Klik tombol **"Tambah ke Keranjang"**

**Hasil:**
- Produk muncul di tabel keranjang
- Subtotal = Harga × Qty
- Total belanja terupdate otomatis

---

### 4.4 Mengubah Jumlah di Keranjang

**Langkah:**
1. Di tabel keranjang, gunakan tombol **"+"** atau **"-"**:
   - **+**: Tambah qty
   - **-**: Kurangi qty
2. Total belanja terupdate otomatis

**Catatan:**
- Jika qty mencapai 0, item akan otomatis dihapus

---

### 4.5 Menghapus Item dari Keranjang

**Langkah:**
1. Di tabel keranjang, klik tombol **"X"** pada item
2. Item langsung terhapus dari keranjang

**Atau:**
- Kurangi qty hingga 0 dengan tombol **"-"**

---

### 4.6 Proses Checkout

**Langkah:**
1. Pastikan keranjang tidak kosong
2. Klik tombol **"Checkout"**
3. Muncul dialog pilihan metode pembayaran:
   - **Tunai (Cash)**
   - **E-Wallet**
4. Pilih metode pembayaran
5. Klik **"Bayar"** atau **"OK"**

**Hasil Sukses:**
- ✅ Transaksi tersimpan ke database
- ✅ Stok produk berkurang otomatis
- ✅ Muncul struk digital
- ✅ Keranjang ter-clear (kosong lagi)

**Jika Gagal:**
- ❌ Muncul pesan error
- ❌ Transaksi tidak tersimpan
- ❌ Keranjang tetap ada (bisa dicoba lagi)

---

### 4.7 Melihat Struk

![Struk/Receipt](../screenshots/receipt.png)

Setelah checkout berhasil, muncul dialog struk yang berisi:
- **ID Transaksi**: Nomor unik transaksi
- **Tanggal & Waktu**
- **Daftar Item**: Nama produk, qty, subtotal
- **Total Pembayaran**
- **Metode Pembayaran**

**Langkah:**
1. Baca struk untuk konfirmasi
2. (Opsional) Screenshot atau print struk
3. Klik **"OK"** untuk tutup dialog

---

### 4.8 Logout

**Langkah:**
1. Klik tombol **"Logout"**
2. Aplikasi kembali ke halaman Login

**Catatan:**
- Pastikan tidak ada transaksi pending sebelum logout

---

## 5. Troubleshooting (Pemecahan Masalah)

### 5.1 Login Gagal

**Masalah:** Muncul pesan "Login gagal!"

**Solusi:**
- ✅ Cek username dan password (case-sensitive)
- ✅ Pastikan kredensial sesuai dengan data di database
- ✅ Cek koneksi database (lihat console untuk error message)

---

### 5.2 Tabel Produk Kosong

**Masalah:** Tabel produk tidak menampilkan data

**Solusi:**
- ✅ Pastikan database sudah ada data produk (run seed data)
- ✅ Cek koneksi database di `DatabaseConnection.java`
- ✅ Cek console untuk error message
- ✅ Refresh aplikasi (logout lalu login lagi)

---

### 5.3 Checkout Gagal

**Masalah:** Muncul error saat checkout

**Kemungkinan Penyebab:**
- Stok produk tidak cukup
- Koneksi database terputus
- Qty di keranjang melebihi stok

**Solusi:**
- ✅ Cek stok produk di database
- ✅ Kurangi qty di keranjang
- ✅ Cek console untuk detail error

---

### 5.4 Aplikasi Tidak Bisa Dibuka

**Masalah:** Error saat run `mvn javafx:run`

**Solusi:**
- ✅ Pastikan Java 17+ sudah terinstall (`java -version`)
- ✅ Pastikan Maven sudah terinstall (`mvn -version`)
- ✅ Pastikan PostgreSQL berjalan
- ✅ Cek file `pom.xml` tidak corrupt
- ✅ Run `mvn clean install` terlebih dahulu

---

### 5.5 Database Connection Error

**Masalah:** Console menampilkan `SQLException` atau `Connection refused`

**Solusi:**
1. Pastikan PostgreSQL sudah berjalan:
   ```bash
   # Windows (via Services)
   services.msc → Cari PostgreSQL → Start
   
   # Linux/Mac
   sudo systemctl start postgresql
   ```

2. Cek kredensial di `DatabaseConnection.java`:
   ```java
   private static final String URL = "jdbc:postgresql://localhost:5432/agripos";
   private static final String USER = "postgres";
   private static final String PASSWORD = "your_password";  // Ganti dengan password Anda
   ```

3. Test koneksi manual via psql:
   ```bash
   psql -U postgres -d agripos
   ```

---

## 6. Tips & Best Practices

### 6.1 Untuk Admin
- ✅ Backup database secara berkala
- ✅ Cek stok produk sebelum dipromosikan
- ✅ Review laporan penjualan setiap hari
- ✅ Jangan hapus produk yang masih aktif dijual

### 6.2 Untuk Kasir
- ✅ Selalu cek qty sebelum checkout
- ✅ Konfirmasi metode pembayaran dengan customer
- ✅ Pastikan keranjang ter-clear setelah checkout
- ✅ Logout setelah selesai shift

### 6.3 Umum
- ✅ Jangan share kredensial login
- ✅ Logout saat tidak digunakan
- ✅ Laporkan bug/error ke admin/developer

---

## 7. Keyboard Shortcuts (Optional)

| Shortcut | Action |
|----------|--------|
| `Enter` | Submit form / Login |
| `Esc` | Close dialog |
| `Ctrl+F` | Focus ke search box (jika diimplementasi) |

---

## 8. FAQ (Frequently Asked Questions)

### Q1: Apakah bisa menambah user baru?
**A:** Ya, admin bisa insert manual via SQL ke tabel `users`.

### Q2: Apakah aplikasi bisa offline?
**A:** Tidak, aplikasi membutuhkan koneksi ke database PostgreSQL.

### Q3: Bagaimana cara menambah metode pembayaran baru?
**A:** Perlu modifikasi kode (tambah class baru yang implement `PaymentMethod`).

### Q4: Apakah bisa export laporan ke Excel?
**A:** Belum diimplementasi di versi ini (future feature).

### Q5: Apakah data transaksi bisa dihapus?
**A:** Bisa via SQL manual, tapi tidak disarankan (untuk audit trail).

---

## 9. Kontak Support

Jika mengalami masalah yang tidak tercantum di panduan ini, hubungi:

**Development Team:**
- Email: [isi email kelompok]
- WhatsApp: [isi nomor]

**Product Owner:**
- [Nama Dosen]
- Email: [email dosen]

---

## 10. Changelog (Riwayat Versi)

| Versi | Tanggal | Perubahan |
|-------|---------|-----------|
| 1.0 | Jan 2026 | Release awal |

---

**Terima kasih telah menggunakan Agri-POS!** 🌾

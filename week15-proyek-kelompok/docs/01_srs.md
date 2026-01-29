# Software Requirements Specification (SRS)
## Agri-POS - Sistem Point of Sale untuk Produk Pertanian

**Versi:** 1.0  
**Tanggal:** Januari 2026  
**Tim Pengembang:** Kelompok 1 - 3 IKKA
Nama Kelompok :
Hari Cahyono
Inayah Fihanatin
Kavina Reyna Riyadi
M.Rifqi An Naafi
Irwandi Isnugroho

---

## 1. Pendahuluan

### 1.1 Tujuan Dokumen
Dokumen ini menjelaskan kebutuhan fungsional dan non-fungsional untuk sistem Agri-POS, sebuah aplikasi Point of Sale berbasis JavaFX yang terintegrasi dengan database PostgreSQL.

### 1.2 Ruang Lingkup Sistem
Agri-POS adalah sistem kasir digital yang dirancang untuk:
- Memudahkan kasir dalam melakukan transaksi penjualan
- Membantu admin mengelola produk dan melihat laporan
- Mendukung berbagai metode pembayaran (Tunai, E-Wallet)
- Menyimpan data transaksi untuk keperluan laporan

### 1.3 Target Pengguna
- **Kasir**: Staff yang melakukan transaksi penjualan
- **Admin**: Pengelola sistem yang mengelola produk dan laporan

---

## 2. Functional Requirements (FR)

### FR-1: Manajemen Produk
**Deskripsi:** Sistem harus menyediakan fitur CRUD (Create, Read, Update, Delete) untuk data produk.

**Acceptance Criteria:**
- Admin dapat menambah produk baru dengan atribut: kode, nama, kategori, harga, stok
- Admin dapat mengubah data produk yang sudah ada
- Admin dapat menghapus produk dari sistem
- Admin dapat melihat daftar semua produk dalam bentuk tabel
- Data produk tersimpan di PostgreSQL dan tampil real-time di UI

**Implementasi:**
- Entity: `Product`
- Service: `ProductService`
- DAO: `JdbcProductRepository`
- Controller: `AdminController`
- UI: `admin.fxml`

---

### FR-2: Transaksi Penjualan
**Deskripsi:** Sistem harus mendukung proses transaksi penjualan dari awal hingga checkout.

**Acceptance Criteria:**
- Kasir dapat membuat transaksi baru
- Kasir dapat mencari produk dari katalog
- Kasir dapat menambah produk ke keranjang belanja
- Kasir dapat mengubah jumlah (quantity) item di keranjang
- Kasir dapat menghapus item dari keranjang
- Sistem menghitung total belanja secara otomatis
- Transaksi tersimpan ke database setelah checkout berhasil

**Implementasi:**
- Entity: `Cart`, `CartItem`, `Transaction`
- Service: `ProductService`, `TransactionRepository`
- Controller: `PosController`
- UI: `pos.fxml`

---

### FR-3: Metode Pembayaran
**Deskripsi:** Sistem harus mendukung pembayaran dengan metode Tunai dan E-Wallet.

**Acceptance Criteria:**
- Kasir dapat memilih metode pembayaran saat checkout
- Sistem mendukung pembayaran Tunai (Cash)
- Sistem mendukung pembayaran E-Wallet
- Desain harus extensible (mudah menambah metode baru tanpa ubah kode inti)
- Menggunakan Design Pattern Strategy/Factory untuk implementasi

**Implementasi:**
- Interface: `PaymentMethod`
- Concrete Classes: `CashPayment`, `EWalletPayment`
- Factory: `PaymentFactory`
- Service: `PaymentService`

**Design Pattern:** Strategy + Factory Method (Open-Closed Principle)

---

### FR-4: Struk dan Laporan
**Deskripsi:** Sistem harus menampilkan struk setelah pembayaran berhasil dan menyediakan laporan penjualan.

**Acceptance Criteria:**
- Setelah checkout berhasil, sistem menampilkan struk digital (preview di UI)
- Struk mencakup: ID Transaksi, tanggal, list item, total, metode pembayaran
- Admin dapat melihat laporan penjualan (omzet harian/periodik)
- Laporan menampilkan total penjualan dalam format mata uang

**Implementasi:**
- Service: `ReportService`
- Controller: `AdminController`, `PosController`
- Database: Tabel `transactions`

---

### FR-5: Login dan Hak Akses
**Deskripsi:** Sistem harus memiliki mekanisme autentikasi dan otorisasi berdasarkan role.

**Acceptance Criteria:**
- User harus login sebelum mengakses sistem
- Sistem mendukung 2 role: **Kasir** dan **Admin**
- Kasir hanya dapat mengakses fitur transaksi (POS)
- Admin dapat mengakses fitur manajemen produk dan laporan
- Sistem mengarahkan user ke halaman sesuai role setelah login berhasil
- User dapat logout dari sistem

**Implementasi:**
- Entity: `User`
- Service: `AuthService`
- Controller: `LoginController`
- UI: `login.fxml`
- Database: Tabel `users`

---

## 3. Non-Functional Requirements (NFR)

### NFR-1: Usability
- UI harus intuitif dan mudah digunakan
- Tidak memerlukan pelatihan khusus untuk kasir
- Response time untuk setiap aksi < 2 detik

### NFR-2: Reliability
- Sistem harus stabil dan tidak crash saat operasi normal
- Data transaksi harus konsisten (tidak boleh hilang)
- Koneksi database harus ter-handle dengan baik (error handling)

### NFR-3: Maintainability
- Kode harus mengikuti prinsip SOLID
- Layering yang jelas: View → Controller → Service → DAO → DB
- Tidak ada SQL di layer GUI
- Menggunakan Design Pattern yang sesuai

### NFR-4: Security
- Password user harus disimpan dengan aman (hash - optional untuk prototype)
- Validasi input untuk mencegah SQL Injection (menggunakan PreparedStatement)
- Role-based access control

### NFR-5: Performance
- Aplikasi harus dapat menampilkan 1000+ produk tanpa lag
- Query database harus optimal (indexing di kolom kode produk)

---

## 4. Data Requirements

### 4.1 Entitas Utama
1. **User**: username, password, role
2. **Product**: kode (PK), nama, kategori, harga, stok
3. **Transaction**: id (PK), tanggal, total_amount
4. **Transaction_Items**: transaction_id (FK), product_code (FK), quantity, subtotal

### 4.2 Business Rules
- Kode produk harus unik
- Stok produk tidak boleh negatif
- Quantity item di keranjang harus > 0
- Total transaksi harus > 0
- Kasir tidak boleh mengakses menu admin
- Admin tidak wajib melakukan transaksi (opsional)

---

## 5. Constraints & Assumptions

### Constraints
- Menggunakan Java 17+
- Menggunakan JavaFX untuk GUI
- Database: PostgreSQL
- Build tool: Maven
- Tidak menggunakan framework ORM (harus manual JDBC)

### Assumptions
- Aplikasi berjalan di lingkungan lokal (tidak cloud)
- Database sudah ter-setup sebelum run aplikasi
- Satu instance aplikasi (tidak multi-user concurrent editing)
- Koneksi database selalu tersedia saat runtime

---

## 6. Use Case Overview

| Use Case ID | Nama Use Case | Aktor | Prioritas |
|-------------|---------------|-------|-----------|
| UC-01 | Login ke Sistem | Kasir, Admin | High |
| UC-02 | Kelola Produk (CRUD) | Admin | High |
| UC-03 | Cari Produk | Kasir | High |
| UC-04 | Tambah ke Keranjang | Kasir | High |
| UC-05 | Update Qty Keranjang | Kasir | Medium |
| UC-06 | Hapus Item Keranjang | Kasir | Medium |
| UC-07 | Checkout & Bayar | Kasir | High |
| UC-08 | Pilih Metode Pembayaran | Kasir | High |
| UC-09 | Tampil Struk | Kasir | Medium |
| UC-10 | Lihat Laporan Penjualan | Admin | Medium |
| UC-11 | Logout | Kasir, Admin | Low |

---

## 7. Acceptance Testing

Setiap FR harus divalidasi dengan test case yang mencakup:
- **Happy Path**: Alur normal yang berhasil
- **Alternative Path**: Alur alternatif (misalnya: pembayaran gagal)
- **Error Handling**: Validasi input, koneksi database gagal, dll

Detail test case ada di dokumen `04_test_plan.md`.

---

## 8. Traceability Matrix

| Requirement | Design (UML) | Implementation | Test Case | Status |
|-------------|--------------|----------------|-----------|--------|
| FR-1 | UC-02, SD-TambahProduk | ProductService, JdbcProductRepository | TC-FR1-01 ~ TC-FR1-04 | ✅ |
| FR-2 | UC-03 ~ UC-07, SD-Checkout | Cart, CartItem, PosController | TC-FR2-01 ~ TC-FR2-05 | ✅ |
| FR-3 | UC-08 | PaymentMethod, PaymentFactory | TC-FR3-01 ~ TC-FR3-02 | ✅ |
| FR-4 | UC-09, UC-10 | ReportService | TC-FR4-01 ~ TC-FR4-02 | ✅ |
| FR-5 | UC-01, UC-11 | AuthService, User | TC-FR5-01 ~ TC-FR5-03 | ✅ |

---

**Catatan:**
- Dokumen ini adalah living document dan dapat diperbarui seiring perkembangan proyek
- Setiap perubahan requirement harus di-review dan di-approve oleh semua stakeholder

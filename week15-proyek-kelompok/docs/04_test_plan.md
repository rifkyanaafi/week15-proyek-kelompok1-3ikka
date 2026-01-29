# Test Plan - Agri-POS

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

## 1. Test Objectives

Memastikan sistem Agri-POS berfungsi sesuai dengan requirements (FR-1 hingga FR-5) dan bebas dari bug kritis sebelum deployment.

**Target:**
- ✅ Semua Functional Requirements ter-cover test case
- ✅ Minimal 80% pass rate untuk test manual
- ✅ Minimal 3 unit test berhasil dijalankan
- ✅ Zero critical bugs sebelum release

---

## 2. Test Strategy

### 2.1 Test Levels

| Level | Deskripsi | Coverage |
|-------|-----------|----------|
| **Unit Testing** | Test individual class/method (non-UI) | Service layer, domain logic |
| **Integration Testing** | Test interaksi antar layer | Controller-Service-DAO-DB |
| **System Testing** | Test end-to-end flow | Full user journey |
| **Acceptance Testing** | Test sesuai requirement | FR-1 ~ FR-5 |

### 2.2 Test Types

- **Functional Testing**: Apakah fitur bekerja sesuai spec?
- **Usability Testing**: Apakah UI mudah digunakan?
- **Error Handling Testing**: Apakah error ter-handle dengan baik?
- **Database Testing**: Apakah data tersimpan dengan benar?

### 2.3 Test Approach

- **Manual Testing**: UI flow, user experience
- **Automated Unit Testing**: JUnit untuk business logic
- **Exploratory Testing**: Ad-hoc testing untuk edge cases

---

## 3. Test Scope

### In Scope
- ✅ FR-1: Manajemen Produk (CRUD)
- ✅ FR-2: Transaksi Penjualan
- ✅ FR-3: Metode Pembayaran
- ✅ FR-4: Struk dan Laporan
- ✅ FR-5: Login dan Hak Akses

### Out of Scope
- ❌ Performance testing (load test)
- ❌ Security penetration testing
- ❌ Multi-user concurrent testing
- ❌ Network/offline testing

---

## 4. Test Cases (Manual)

### 4.1 FR-1: Manajemen Produk (CRUD)

#### TC-FR1-01: Tambah Produk Baru (Happy Path)

| ID | TC-FR1-01 |
|----|-----------|
| **Nama** | Tambah produk baru dengan data valid |
| **Precondition** | User login sebagai ADMIN dan berada di halaman admin |
| **Test Data** | Kode: "AGR099", Nama: "Pupuk Test", Kategori: "Pupuk", Harga: 50000, Stok: 100 |

**Test Steps:**
1. Isi field Kode dengan "AGR099"
2. Isi field Nama dengan "Pupuk Test"
3. Isi field Kategori dengan "Pupuk"
4. Isi field Harga dengan "50000"
5. Isi field Stok dengan "100"
6. Klik tombol "Simpan"

**Expected Result:**
- ✅ Produk tersimpan ke database
- ✅ Produk muncul di tabel produk
- ✅ Form di-clear setelah simpan
- ✅ Tidak ada error message

---

#### TC-FR1-02: Update Produk Existing

| ID | TC-FR1-02 |
|----|-----------|
| **Nama** | Update data produk yang sudah ada |
| **Precondition** | Ada produk dengan kode "AGR099" di database |
| **Test Data** | Nama baru: "Pupuk Test Edited", Harga baru: 60000 |

**Test Steps:**
1. Pilih produk "AGR099" dari tabel
2. Ubah field Nama menjadi "Pupuk Test Edited"
3. Ubah field Harga menjadi "60000"
4. Klik tombol "Update"

**Expected Result:**
- ✅ Data produk ter-update di database
- ✅ Tabel refresh dan menampilkan data baru
- ✅ Tidak ada error message

---

#### TC-FR1-03: Hapus Produk

| ID | TC-FR1-03 |
|----|-----------|
| **Nama** | Hapus produk dari sistem |
| **Precondition** | Ada produk dengan kode "AGR099" di database |

**Test Steps:**
1. Pilih produk "AGR099" dari tabel
2. Klik tombol "Hapus"
3. (Optional) Konfirmasi delete jika ada dialog

**Expected Result:**
- ✅ Produk terhapus dari database
- ✅ Produk hilang dari tabel
- ✅ Tidak ada error message

---

#### TC-FR1-04: Lihat Daftar Produk

| ID | TC-FR1-04 |
|----|-----------|
| **Nama** | Tampil semua produk di tabel |
| **Precondition** | Ada minimal 5 produk di database |

**Test Steps:**
1. Login sebagai ADMIN
2. Buka halaman admin

**Expected Result:**
- ✅ Tabel menampilkan semua produk
- ✅ Data sesuai dengan database
- ✅ Kolom: Kode, Nama, Harga, Stok terlihat jelas

---

### 4.2 FR-2: Transaksi Penjualan

#### TC-FR2-01: Cari Produk di POS

| ID | TC-FR2-01 |
|----|-----------|
| **Nama** | Cari produk menggunakan search box |
| **Precondition** | User login sebagai KASIR |
| **Test Data** | Kata kunci: "pupuk" |

**Test Steps:**
1. Di halaman POS, ketik "pupuk" di search box
2. Tunggu tabel katalog ter-filter

**Expected Result:**
- ✅ Tabel hanya menampilkan produk yang mengandung kata "pupuk"
- ✅ Filter case-insensitive (PUPUK = pupuk)

---

#### TC-FR2-02: Tambah Produk ke Keranjang

| ID | TC-FR2-02 |
|----|-----------|
| **Nama** | Tambah produk ke keranjang belanja |
| **Precondition** | Ada produk di katalog dengan stok > 0 |
| **Test Data** | Produk: "AGR001", Qty: 2 |

**Test Steps:**
1. Double-click produk "AGR001" dari katalog
   ATAU
2. Isi field Kode dengan "AGR001", Qty dengan "2", klik "Tambah"

**Expected Result:**
- ✅ Produk muncul di tabel keranjang
- ✅ Subtotal = harga × qty
- ✅ Total belanja ter-update otomatis

---

#### TC-FR2-03: Update Qty di Keranjang

| ID | TC-FR2-03 |
|----|-----------|
| **Nama** | Ubah quantity item di keranjang |
| **Precondition** | Ada item "AGR001" dengan qty 2 di keranjang |

**Test Steps:**
1. Klik tombol "+" pada item AGR001
2. Klik tombol "-" pada item AGR001

**Expected Result:**
- ✅ Qty bertambah saat klik "+"
- ✅ Qty berkurang saat klik "-"
- ✅ Total belanja ter-update otomatis
- ✅ Jika qty = 0, item dihapus dari keranjang

---

#### TC-FR2-04: Hapus Item dari Keranjang

| ID | TC-FR2-04 |
|----|-----------|
| **Nama** | Hapus item dari keranjang |
| **Precondition** | Ada item di keranjang |

**Test Steps:**
1. Klik tombol "X" pada salah satu item

**Expected Result:**
- ✅ Item terhapus dari keranjang
- ✅ Total belanja ter-update
- ✅ Tabel keranjang refresh

---

#### TC-FR2-05: Checkout dengan Keranjang Kosong (Error Case)

| ID | TC-FR2-05 |
|----|-----------|
| **Nama** | Checkout tanpa item di keranjang |
| **Precondition** | Keranjang kosong |

**Test Steps:**
1. Klik tombol "Checkout"

**Expected Result:**
- ✅ Muncul Alert: "Keranjang kosong!"
- ✅ Checkout tidak diproses

---

### 4.3 FR-3: Metode Pembayaran

#### TC-FR3-01: Checkout dengan Pembayaran Tunai

| ID | TC-FR3-01 |
|----|-----------|
| **Nama** | Proses checkout menggunakan Cash |
| **Precondition** | Ada item di keranjang, total > 0 |
| **Test Data** | Metode: "CASH", Total: 150000 |

**Test Steps:**
1. Klik tombol "Checkout"
2. Pilih metode "Tunai" dari dialog
3. Konfirmasi pembayaran

**Expected Result:**
- ✅ Transaksi tersimpan ke database (tabel `transactions` + `transaction_items`)
- ✅ Stok produk berkurang sesuai qty
- ✅ Muncul struk/receipt
- ✅ Keranjang ter-clear
- ✅ Total di struk sesuai dengan total keranjang

---

#### TC-FR3-02: Checkout dengan Pembayaran E-Wallet

| ID | TC-FR3-02 |
|----|-----------|
| **Nama** | Proses checkout menggunakan E-Wallet |
| **Precondition** | Ada item di keranjang |
| **Test Data** | Metode: "EWALLET", Total: 200000 |

**Test Steps:**
1. Klik tombol "Checkout"
2. Pilih metode "E-Wallet" dari dialog
3. Konfirmasi pembayaran

**Expected Result:**
- ✅ Transaksi tersimpan ke database
- ✅ Stok produk berkurang
- ✅ Muncul struk dengan info metode "E-Wallet"
- ✅ Keranjang ter-clear

---

### 4.4 FR-4: Struk dan Laporan

#### TC-FR4-01: Tampil Struk Setelah Checkout

| ID | TC-FR4-01 |
|----|-----------|
| **Nama** | Struk muncul setelah pembayaran berhasil |
| **Precondition** | Checkout berhasil dengan total 150000 |

**Expected Result:**
- ✅ Muncul Alert/Dialog struk
- ✅ Struk berisi: ID Transaksi, List Item, Total, Metode Pembayaran
- ✅ Format mata uang readable (Rp 150.000)

---

#### TC-FR4-02: Lihat Laporan Penjualan Harian

| ID | TC-FR4-02 |
|----|-----------|
| **Nama** | Admin melihat omzet harian |
| **Precondition** | Login sebagai ADMIN, ada transaksi hari ini |

**Test Steps:**
1. Klik tombol "Lihat Laporan" di halaman admin

**Expected Result:**
- ✅ Muncul total omzet harian
- ✅ Format: Rp XXX.XXX
- ✅ Nilai sesuai dengan SUM(total_amount) di database

---

### 4.5 FR-5: Login dan Hak Akses

#### TC-FR5-01: Login sebagai Admin (Happy Path)

| ID | TC-FR5-01 |
|----|-----------|
| **Nama** | Login dengan kredensial Admin |
| **Test Data** | Username: "admin", Password: "admin123" |

**Test Steps:**
1. Isi field Username dengan "admin"
2. Isi field Password dengan "admin123"
3. Klik tombol "Login"

**Expected Result:**
- ✅ Login berhasil
- ✅ Redirect ke halaman Admin (admin.fxml)
- ✅ Dapat akses fitur CRUD produk dan laporan

---

#### TC-FR5-02: Login sebagai Kasir

| ID | TC-FR5-02 |
|----|-----------|
| **Nama** | Login dengan kredensial Kasir |
| **Test Data** | Username: "kasir1", Password: "kasir123" |

**Test Steps:**
1. Isi field Username dengan "kasir1"
2. Isi field Password dengan "kasir123"
3. Klik tombol "Login"

**Expected Result:**
- ✅ Login berhasil
- ✅ Redirect ke halaman POS (pos.fxml)
- ✅ Dapat akses fitur transaksi

---

#### TC-FR5-03: Login dengan Kredensial Salah (Error Case)

| ID | TC-FR5-03 |
|----|-----------|
| **Nama** | Login dengan password salah |
| **Test Data** | Username: "admin", Password: "wrongpass" |

**Test Steps:**
1. Isi field Username dengan "admin"
2. Isi field Password dengan "wrongpass"
3. Klik tombol "Login"

**Expected Result:**
- ✅ Login gagal
- ✅ Muncul Alert: "Login gagal!"
- ✅ Tetap di halaman login

---

## 5. Unit Test Cases (JUnit)

### 5.1 CartTest

```java
@Test
public void testAddItemToCart() {
    // Arrange
    Cart cart = new Cart();
    Product product = new Product("AGR001", "Pupuk", "Pupuk", 50000, 100);
    
    // Act
    cart.addItem(product, 2);
    
    // Assert
    assertEquals(1, cart.getItems().size());
    assertEquals(100000, cart.getTotal(), 0.01);
}

@Test
public void testUpdateQtyInCart() {
    Cart cart = new Cart();
    Product product = new Product("AGR001", "Pupuk", "Pupuk", 50000, 100);
    cart.addItem(product, 2);
    
    // Act
    cart.updateQty("AGR001", 5);
    
    // Assert
    assertEquals(5, cart.getItems().get(0).getQuantity());
    assertEquals(250000, cart.getTotal(), 0.01);
}

@Test
public void testRemoveItemFromCart() {
    Cart cart = new Cart();
    Product product = new Product("AGR001", "Pupuk", "Pupuk", 50000, 100);
    cart.addItem(product, 2);
    
    // Act
    cart.removeItem("AGR001");
    
    // Assert
    assertEquals(0, cart.getItems().size());
    assertEquals(0, cart.getTotal(), 0.01);
}
```

---

### 5.2 PaymentTest

```java
@Test
public void testCashPayment() {
    PaymentMethod payment = new CashPayment();
    boolean result = payment.pay(100000);
    assertTrue(result);
}

@Test
public void testEWalletPayment() {
    PaymentMethod payment = new EWalletPayment();
    boolean result = payment.pay(150000);
    assertTrue(result);
}

@Test
public void testPaymentFactory() {
    PaymentMethod cash = PaymentFactory.getPaymentMethod("CASH");
    assertNotNull(cash);
    assertTrue(cash instanceof CashPayment);
    
    PaymentMethod ewallet = PaymentFactory.getPaymentMethod("EWALLET");
    assertNotNull(ewallet);
    assertTrue(ewallet instanceof EWalletPayment);
}
```

---

## 6. Test Environment

### 6.1 Hardware
- OS: Windows 10/11 atau Linux
- RAM: Minimum 4GB
- Storage: 1GB free space

### 6.2 Software
- Java: 17+
- JavaFX: 17.0.6
- PostgreSQL: 14+
- Maven: 3.8+
- JUnit: 4.13.2

### 6.3 Test Database
- Database Name: `agripos_test`
- User: `postgres`
- Password: `test123`
- Seed data: 10 produk, 3 user

---

## 7. Test Schedule

| Phase | Activity | Duration | PIC |
|-------|----------|----------|-----|
| Week 1 | Unit Testing | 2 hari | [Nama Anggota 1] |
| Week 1 | Manual Test Case Execution | 2 hari | [Nama Anggota 2] |
| Week 2 | Bug Fixing | 2 hari | [Semua Anggota] |
| Week 2 | Regression Testing | 1 hari | [Nama Anggota 3] |
| Week 2 | Test Report & Documentation | 1 hari | [Nama QA Lead] |

---

## 8. Test Deliverables

- ✅ Test Plan (dokumen ini)
- ✅ Test Cases (manual - dalam dokumen ini)
- ✅ Unit Test Code (CartTest.java, PaymentTest.java)
- ✅ Test Report (05_test_report.md)
- ✅ Screenshot bukti test (screenshots/)

---

## 9. Entry & Exit Criteria

### Entry Criteria (Kapan testing dimulai)
- ✅ Semua fitur wajib (FR-1 ~ FR-5) sudah diimplementasi
- ✅ Aplikasi dapat di-compile tanpa error
- ✅ Database schema sudah final

### Exit Criteria (Kapan testing selesai)
- ✅ Semua test case ter-execute
- ✅ Pass rate >= 80%
- ✅ Zero critical bugs
- ✅ Test report sudah dibuat

---

## 10. Risk & Mitigation

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Database koneksi gagal | Medium | High | Mock DAO untuk unit test |
| UI tidak responsive | Low | Medium | Manual testing dengan berbagai resolusi |
| Bug ditemukan H-1 deadline | Medium | High | Buffer time 2 hari untuk bug fixing |

---

## Approval

| Role | Nama | Tanggal | Signature |
|------|------|---------|-----------|
| QA Lead | [Nama] | | |
| Development Lead | [Nama] | | |
| Product Owner | [Nama Dosen] | | |

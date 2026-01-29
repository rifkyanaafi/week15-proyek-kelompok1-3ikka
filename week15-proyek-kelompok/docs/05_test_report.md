# Test Report - Agri-POS

**Versi:** 1.0  
**Tanggal Eksekusi:** 29 Febuari 2026 

---

## 1. Executive Summary

Test Report ini merangkum hasil eksekusi test plan untuk sistem Agri-POS. Testing dilakukan untuk memvalidasi bahwa semua Functional Requirements (FR-1 hingga FR-5) berfungsi sesuai spesifikasi.

### 1.1 Test Metrics

| Metric | Value |
|--------|-------|
| Total Test Cases | 13 manual + 6 unit tests |
| Executed | [Isi jumlah] |
| Passed | [Isi jumlah] ✅ |
| Failed | [Isi jumlah] ❌ |
| Blocked | [Isi jumlah] ⚠️ |
| Pass Rate | [Isi %] % |

### 1.2 Overall Status

**Status:** ✅ PASS / ⚠️ WARNING / ❌ FAIL

**Summary:**
- [Isi ringkasan singkat hasil testing, misal: "Semua fitur utama berfungsi dengan baik. Ada 2 minor bugs yang tidak menghambat operasi."]

---

## 2. Test Execution Results (Manual Testing)

### 2.1 FR-1: Manajemen Produk (CRUD)

| Test Case ID | Test Name | Status | Comment |
|--------------|-----------|--------|---------|
| TC-FR1-01 | Tambah Produk Baru | ✅ PASS | Produk berhasil tersimpan |
| TC-FR1-02 | Update Produk | ✅ PASS | Update berhasil |
| TC-FR1-03 | Hapus Produk | ✅ PASS | Delete berhasil |
| TC-FR1-04 | Lihat Daftar Produk | ✅ PASS | Tabel menampilkan semua produk |

**Screenshot Bukti:**
- ![CRUD Produk](../screenshots/fr1_crud_produk.png)

**Notes:**
- [Isi catatan jika ada]

---

### 2.2 FR-2: Transaksi Penjualan

| Test Case ID | Test Name | Status | Comment |
|--------------|-----------|--------|---------|
| TC-FR2-01 | Cari Produk di POS | ✅ PASS | Filter berfungsi case-insensitive |
| TC-FR2-02 | Tambah ke Keranjang | ✅ PASS | Item masuk keranjang, total terupdate |
| TC-FR2-03 | Update Qty Keranjang | ✅ PASS | Tombol +/- berfungsi |
| TC-FR2-04 | Hapus Item Keranjang | ✅ PASS | Item terhapus dengan tombol X |
| TC-FR2-05 | Checkout Kosong | ✅ PASS | Alert muncul: "Keranjang kosong!" |

**Screenshot Bukti:**
- ![Keranjang Belanja](../screenshots/fr2_cart.png)
- ![Checkout Flow](../screenshots/fr2_checkout.png)

**Notes:**
- [Isi catatan jika ada]

---

### 2.3 FR-3: Metode Pembayaran

| Test Case ID | Test Name | Status | Comment |
|--------------|-----------|--------|---------|
| TC-FR3-01 | Checkout Cash | ✅ PASS | Transaksi tersimpan, struk muncul |
| TC-FR3-02 | Checkout E-Wallet | ✅ PASS | Metode E-Wallet berhasil |

**Screenshot Bukti:**
- ![Pilih Metode Pembayaran](../screenshots/fr3_payment_method.png)

**Notes:**
- Payment Strategy pattern berfungsi dengan baik (extensible)

---

### 2.4 FR-4: Struk dan Laporan

| Test Case ID | Test Name | Status | Comment |
|--------------|-----------|--------|---------|
| TC-FR4-01 | Tampil Struk | ✅ PASS | Struk menampilkan detail lengkap |
| TC-FR4-02 | Laporan Penjualan | ✅ PASS | Omzet harian sesuai database |

**Screenshot Bukti:**
- ![Struk](../screenshots/fr4_receipt.png)
- ![Laporan Omzet](../screenshots/fr4_report.png)

**Notes:**
- [Isi catatan jika ada]

---

### 2.5 FR-5: Login dan Hak Akses

| Test Case ID | Test Name | Status | Comment |
|--------------|-----------|--------|---------|
| TC-FR5-01 | Login Admin | ✅ PASS | Redirect ke admin.fxml |
| TC-FR5-02 | Login Kasir | ✅ PASS | Redirect ke pos.fxml |
| TC-FR5-03 | Login Gagal | ✅ PASS | Alert muncul: "Login gagal!" |

**Screenshot Bukti:**
- ![Login Screen](../screenshots/fr5_login.png)
- ![Admin Dashboard](../screenshots/fr5_admin.png)
- ![POS Dashboard](../screenshots/fr5_pos.png)

**Notes:**
- Role-based routing berfungsi dengan baik

---

## 3. Unit Test Results (JUnit)

### 3.1 CartTest

```
Running com.upb.agripos.CartTest
testAddItemToCart          ✅ PASS  (12ms)
testUpdateQtyInCart        ✅ PASS  (8ms)
testRemoveItemFromCart     ✅ PASS  (5ms)
testGetTotal               ✅ PASS  (3ms)

Tests run: 4, Failures: 0, Errors: 0, Skipped: 0
```

**Screenshot:**
![JUnit CartTest](../screenshots/junit_cart_test.png)

---

### 3.2 PaymentTest

```
Running com.upb.agripos.PaymentTest
testCashPayment            ✅ PASS  (4ms)
testEWalletPayment         ✅ PASS  (3ms)
testPaymentFactory         ✅ PASS  (2ms)

Tests run: 3, Failures: 0, Errors: 0, Skipped: 0
```

**Screenshot:**
![JUnit PaymentTest](../screenshots/junit_payment_test.png)

---

## 4. Defect Summary

### 4.1 Bugs Found

| Bug ID | Severity | Description | Status | Fixed By |
|--------|----------|-------------|--------|----------|
| BUG-001 | 🔴 Critical | [Contoh: Database koneksi timeout] | ✅ Fixed | [Nama] |
| BUG-002 | 🟡 Medium | [Contoh: Struk tidak format angka dengan koma] | ✅ Fixed | [Nama] |
| BUG-003 | 🟢 Low | [Contoh: Typo di label button] | ⏳ Open | [Nama] |

**Note:** Jika tidak ada bug, tuliskan "No defects found during testing phase."

---

### 4.2 Known Issues (Optional)

- [Isi daftar known issues yang tidak di-fix karena low priority, misal: "Alert box tidak ada icon, hanya text."]

---

## 5. Test Coverage Analysis

### 5.1 Functional Coverage

| Requirement | Covered | Notes |
|-------------|---------|-------|
| FR-1: Manajemen Produk | ✅ 100% | All CRUD operations tested |
| FR-2: Transaksi Penjualan | ✅ 100% | Cart operations + checkout |
| FR-3: Metode Pembayaran | ✅ 100% | Cash + E-Wallet tested |
| FR-4: Struk & Laporan | ✅ 100% | Receipt + report verified |
| FR-5: Login & Role | ✅ 100% | Both roles tested |

**Overall Functional Coverage:** ✅ 100%

---

### 5.2 Code Coverage (Unit Test)

| Module | Coverage | Notes |
|--------|----------|-------|
| `Cart.java` | ✅ ~80% | Main logic covered |
| `CartItem.java` | ✅ ~70% | Getter/setter tested |
| `PaymentMethod` classes | ✅ ~60% | Strategy pattern tested |
| `ProductService` | ⚠️ ~40% | Perlu tambahan test |
| `TransactionRepository` | ❌ Not tested | Perlu integration test |

**Note:** Code coverage bisa ditingkatkan dengan menambah unit test untuk Service layer.

---

## 6. Database Testing

### 6.1 Data Integrity Check

| Check | Result | Comment |
|-------|--------|---------|
| Transaksi tersimpan dengan benar | ✅ PASS | Verified via SQL query |
| Stok produk ter-update setelah checkout | ✅ PASS | Stok berkurang sesuai qty |
| Foreign key constraint berfungsi | ✅ PASS | Cannot delete product with transactions |
| Check constraint (stok >= 0) | ✅ PASS | Database reject negative stock |

**Screenshot:**
![Database Verification](../screenshots/db_verification.png)

---

### 6.2 Sample Queries for Verification

```sql
-- Verify transaction saved
SELECT * FROM transactions WHERE id = 'TRX-TEST-001';

-- Verify transaction items
SELECT * FROM transaction_items WHERE transaction_id = 'TRX-TEST-001';

-- Verify stock reduced
SELECT kode, nama, stok FROM products WHERE kode = 'AGR001';
```

---

## 7. Performance Testing (Optional)

| Scenario | Response Time | Status |
|----------|---------------|--------|
| Load 100 produk ke tabel | [Isi] ms | ✅ < 500ms |
| Tambah produk ke keranjang | [Isi] ms | ✅ < 100ms |
| Execute checkout | [Isi] ms | ✅ < 1s |
| Generate laporan | [Isi] ms | ✅ < 1s |

**Note:** Performance testing dilakukan secara manual dengan stopwatch.

---

## 8. Usability Testing Feedback

**Tester:** [Nama user non-teknis]

**Feedback Positif:**
- UI intuitif dan mudah dipahami
- Button placement logical
- Search filter responsive

**Feedback Improvement:**
- [Isi saran perbaikan jika ada]

---

## 9. Traceability Matrix (Test Coverage)

| Requirement | Test Case(s) | Status | Evidence |
|-------------|--------------|--------|----------|
| FR-1 Manajemen Produk | TC-FR1-01 ~ TC-FR1-04 | ✅ PASS | Screenshot + DB verify |
| FR-2 Transaksi | TC-FR2-01 ~ TC-FR2-05 | ✅ PASS | Screenshot + JUnit |
| FR-3 Pembayaran | TC-FR3-01 ~ TC-FR3-02 | ✅ PASS | Screenshot + JUnit |
| FR-4 Struk & Laporan | TC-FR4-01 ~ TC-FR4-02 | ✅ PASS | Screenshot |
| FR-5 Login & Role | TC-FR5-01 ~ TC-FR5-03 | ✅ PASS | Screenshot |

---

## 10. Recommendations

### 10.1 Before Release
- ✅ Fix all critical bugs
- ✅ Retest failed test cases
- ✅ Verify all screenshots included in documentation

### 10.2 Future Improvements
- 🔹 Tambah unit test untuk Service layer (target: 70% coverage)
- 🔹 Implementasi integration test untuk DAO layer
- 🔹 Tambah validation error message yang lebih jelas
- 🔹 Implementasi confirmation dialog untuk delete action

---

## 11. Test Environment Details

**Hardware:**
- CPU: [Isi spec]
- RAM: [Isi spec]
- OS: [Windows 11 / Linux / Mac]

**Software:**
- Java: 17.0.6
- JavaFX: 17.0.6
- PostgreSQL: 14.7
- Maven: 3.8.6

**Database:**
- Database Name: `agripos_test`
- Seed Data: 8 produk, 3 users

---

## 12. Conclusion

**Overall Assessment:** ✅ READY FOR RELEASE / ⚠️ NEEDS MINOR FIX / ❌ NOT READY

**Summary:**
[Isi kesimpulan akhir, misal:
"Sistem Agri-POS telah melewati semua test cases dengan pass rate 95%. Semua functional requirements (FR-1 hingga FR-5) berfungsi sesuai spesifikasi. Terdapat 2 minor bugs yang telah di-fix. Sistem siap untuk demo dan deployment."]

**Recommendations:**
- ✅ Proceed with deployment
- 🔹 Monitor system in production for any unexpected issues
- 🔹 Collect user feedback for next iteration

## Attachments

### Screenshots Directory
```
screenshots/
├─ fr1_crud_produk.png
├─ fr2_cart.png
├─ fr2_checkout.png
├─ fr3_payment_method.png
├─ fr4_receipt.png
├─ fr4_report.png
├─ fr5_login.png
├─ fr5_admin.png
├─ fr5_pos.png
├─ junit_cart_test.png
├─ junit_payment_test.png
└─ db_verification.png
```

### Test Data Files
- `test_products.sql` - Sample test data
- `test_users.sql` - Test user credentials

---

**Document End**

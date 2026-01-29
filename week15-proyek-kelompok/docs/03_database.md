# Database Design - Agri-POS

**Versi:** 1.0  
**Database:** PostgreSQL 14+  
**Tanggal:** Januari 2026

---

## 1. Overview

Database Agri-POS dirancang untuk menyimpan data produk, transaksi, dan user dengan struktur yang normalized (3NF) dan mendukung integritas referensial.

---

## 2. Entity Relationship Diagram (ERD)

```
┌─────────────────┐
│     USERS       │
├─────────────────┤
│ username (PK)   │
│ password        │
│ role            │
└─────────────────┘


┌──────────────────────────┐
│       PRODUCTS           │
├──────────────────────────┤
│ kode (PK)                │
│ nama                     │
│ kategori                 │
│ harga                    │
│ stok                     │
└──────────────────────────┘
            │
            │ 1
            │
            │
            │ N
┌──────────────────────────┐         ┌─────────────────────┐
│   TRANSACTION_ITEMS      │    N    │    TRANSACTIONS     │
├──────────────────────────┤─────────├─────────────────────┤
│ id (PK)                  │    1    │ id (PK)             │
│ transaction_id (FK)      │◄────────│ tanggal             │
│ product_code (FK)        │         │ total_amount        │
│ quantity                 │         └─────────────────────┘
│ subtotal                 │
└──────────────────────────┘
            │
            │ N
            │
            │ 1
            ▼
┌──────────────────────────┐
│       PRODUCTS           │
│       (referenced)       │
└──────────────────────────┘
```

**Relationship:**
- `PRODUCTS` ─(1:N)─ `TRANSACTION_ITEMS` (satu produk bisa muncul di banyak transaksi)
- `TRANSACTIONS` ─(1:N)─ `TRANSACTION_ITEMS` (satu transaksi punya banyak item)

---

## 3. Database Schema (DDL)

### 3.1 Tabel: users

```sql
CREATE TABLE users (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'KASIR'))
);

-- Index untuk performa login
CREATE INDEX idx_users_role ON users(role);
```

**Deskripsi:**
- `username`: Primary Key, identifier unik untuk user
- `password`: Password user (plain text untuk prototype, bisa di-hash untuk production)
- `role`: Role user (ADMIN atau KASIR) untuk otorisasi

**Business Rules:**
- Role hanya boleh 'ADMIN' atau 'KASIR'
- Username harus unik

---

### 3.2 Tabel: products

```sql
CREATE TABLE products (
    kode VARCHAR(20) PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    kategori VARCHAR(50),
    harga DECIMAL(15, 2) NOT NULL CHECK (harga >= 0),
    stok INT NOT NULL DEFAULT 0 CHECK (stok >= 0)
);

-- Index untuk performa pencarian
CREATE INDEX idx_products_nama ON products(nama);
CREATE INDEX idx_products_kategori ON products(kategori);
```

**Deskripsi:**
- `kode`: Primary Key, kode unik produk (misal: "AGR001")
- `nama`: Nama produk
- `kategori`: Kategori produk (misal: "Pupuk", "Bibit", "Pestisida")
- `harga`: Harga satuan produk (tidak boleh negatif)
- `stok`: Jumlah stok tersedia (tidak boleh negatif)

**Business Rules:**
- Kode produk harus unik
- Harga tidak boleh negatif
- Stok tidak boleh negatif

---

### 3.3 Tabel: transactions

```sql
CREATE TABLE transactions (
    id VARCHAR(50) PRIMARY KEY,
    tanggal TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(15, 2) NOT NULL CHECK (total_amount > 0)
);

-- Index untuk performa laporan
CREATE INDEX idx_transactions_tanggal ON transactions(tanggal DESC);
```

**Deskripsi:**
- `id`: Primary Key, ID unik transaksi (generated UUID)
- `tanggal`: Timestamp saat transaksi dibuat (auto-generated)
- `total_amount`: Total nilai transaksi

**Business Rules:**
- ID transaksi harus unik
- Total amount harus > 0

---

### 3.4 Tabel: transaction_items

```sql
CREATE TABLE transaction_items (
    id SERIAL PRIMARY KEY,
    transaction_id VARCHAR(50) NOT NULL REFERENCES transactions(id) ON DELETE CASCADE,
    product_code VARCHAR(20) NOT NULL REFERENCES products(kode) ON DELETE RESTRICT,
    quantity INT NOT NULL CHECK (quantity > 0),
    subtotal DECIMAL(15, 2) NOT NULL CHECK (subtotal >= 0)
);

-- Index untuk performa query
CREATE INDEX idx_transaction_items_trx_id ON transaction_items(transaction_id);
CREATE INDEX idx_transaction_items_product ON transaction_items(product_code);
```

**Deskripsi:**
- `id`: Primary Key auto-increment
- `transaction_id`: Foreign Key ke tabel `transactions`
- `product_code`: Foreign Key ke tabel `products`
- `quantity`: Jumlah item dibeli
- `subtotal`: Subtotal (harga × quantity)

**Business Rules:**
- Quantity harus > 0
- Subtotal harus >= 0
- Jika transaksi dihapus, item ikut terhapus (CASCADE)
- Jika produk masih ada di transaksi, tidak boleh dihapus (RESTRICT)

---

## 4. Sample Data (Seed Data)

### 4.1 Insert Users

```sql
INSERT INTO users (username, password, role) VALUES
('admin', 'admin123', 'ADMIN'),
('kasir1', 'kasir123', 'KASIR'),
('kasir2', 'kasir123', 'KASIR');
```

### 4.2 Insert Products

```sql
INSERT INTO products (kode, nama, kategori, harga, stok) VALUES
('AGR001', 'Pupuk Urea 50kg', 'Pupuk', 150000, 100),
('AGR002', 'Bibit Padi Hibrida', 'Bibit', 75000, 200),
('AGR003', 'Pestisida Organik', 'Pestisida', 120000, 50),
('AGR004', 'Pupuk NPK 25kg', 'Pupuk', 200000, 80),
('AGR005', 'Bibit Jagung Manis', 'Bibit', 50000, 150),
('AGR006', 'Herbisida Rumput', 'Pestisida', 95000, 60),
('AGR007', 'Pupuk Kandang Kompos', 'Pupuk', 30000, 300),
('AGR008', 'Bibit Cabai Rawit', 'Bibit', 40000, 120);
```

### 4.3 Insert Sample Transaction

```sql
-- Transaction 1
INSERT INTO transactions (id, tanggal, total_amount) 
VALUES ('TRX-001', '2026-01-28 10:30:00', 370000);

INSERT INTO transaction_items (transaction_id, product_code, quantity, subtotal) VALUES
('TRX-001', 'AGR001', 2, 300000),  -- 2 x 150000
('TRX-001', 'AGR008', 1, 40000),   -- 1 x 40000
('TRX-001', 'AGR007', 1, 30000);   -- 1 x 30000

-- Transaction 2
INSERT INTO transactions (id, tanggal, total_amount) 
VALUES ('TRX-002', '2026-01-28 14:15:00', 545000);

INSERT INTO transaction_items (transaction_id, product_code, quantity, subtotal) VALUES
('TRX-002', 'AGR004', 2, 400000),  -- 2 x 200000
('TRX-002', 'AGR006', 1, 95000),   -- 1 x 95000
('TRX-002', 'AGR005', 1, 50000);   -- 1 x 50000
```

---

## 5. Query Examples

### 5.1 Cari Produk by Nama (untuk fitur search)

```sql
SELECT * FROM products 
WHERE LOWER(nama) LIKE LOWER('%pupuk%')
ORDER BY nama;
```

### 5.2 Get Omzet Harian (untuk laporan)

```sql
SELECT 
    DATE(tanggal) as tanggal_transaksi,
    COUNT(*) as jumlah_transaksi,
    SUM(total_amount) as total_omzet
FROM transactions
WHERE tanggal >= CURRENT_DATE
GROUP BY DATE(tanggal);
```

### 5.3 Get Detail Transaksi (untuk struk)

```sql
SELECT 
    t.id,
    t.tanggal,
    t.total_amount,
    ti.product_code,
    p.nama as product_name,
    ti.quantity,
    ti.subtotal
FROM transactions t
JOIN transaction_items ti ON t.id = ti.transaction_id
JOIN products p ON ti.product_code = p.kode
WHERE t.id = 'TRX-001';
```

### 5.4 Update Stok Setelah Checkout

```sql
UPDATE products 
SET stok = stok - ? 
WHERE kode = ? AND stok >= ?;
```

### 5.5 Produk dengan Stok Rendah (untuk alert)

```sql
SELECT kode, nama, stok 
FROM products 
WHERE stok < 10 
ORDER BY stok ASC;
```

---

## 6. Database Constraints & Integrity

### 6.1 Primary Keys
- ✅ `users.username`
- ✅ `products.kode`
- ✅ `transactions.id`
- ✅ `transaction_items.id`

### 6.2 Foreign Keys
- ✅ `transaction_items.transaction_id` → `transactions.id`
- ✅ `transaction_items.product_code` → `products.kode`

### 6.3 Check Constraints
- ✅ `users.role IN ('ADMIN', 'KASIR')`
- ✅ `products.harga >= 0`
- ✅ `products.stok >= 0`
- ✅ `transactions.total_amount > 0`
- ✅ `transaction_items.quantity > 0`

### 6.4 Indexes
- ✅ `idx_users_role` - Speed up role filtering
- ✅ `idx_products_nama` - Speed up product search
- ✅ `idx_transactions_tanggal` - Speed up report generation
- ✅ `idx_transaction_items_trx_id` - Speed up join queries

---

## 7. Data Access Pattern (DAO)

### 7.1 ProductRepository Pattern

```java
public interface ProductRepository {
    void addProduct(Product p);
    void updateProduct(Product p);
    void deleteProduct(String kode);
    List<Product> listProducts();
    Product getProductByCode(String kode);
    void reduceStock(String kode, int qty);
}
```

### 7.2 JDBC Implementation dengan PreparedStatement

```java
@Override
public void addProduct(Product p) {
    String sql = "INSERT INTO products (kode, nama, kategori, harga, stok) VALUES (?, ?, ?, ?, ?)";
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setString(1, p.getKode());
        ps.setString(2, p.getNama());
        ps.setString(3, p.getKategori());
        ps.setDouble(4, p.getHarga());
        ps.setInt(5, p.getStok());
        ps.executeUpdate();
        
    } catch (SQLException e) {
        throw new DatabaseException("Gagal menambah produk", e);
    }
}
```

**Keuntungan PreparedStatement:**
- ✅ Prevent SQL Injection
- ✅ Better performance (query pre-compiled)
- ✅ Type safety

---

## 8. Backup & Migration Strategy

### 8.1 Backup Script

```bash
# Backup full database
pg_dump -U postgres -d agripos -F c -f backup_agripos_$(date +%Y%m%d).dump

# Restore
pg_restore -U postgres -d agripos backup_agripos_20260129.dump
```

### 8.2 Migration Files

Gunakan versioned SQL files:
```
database/
├─ V1__initial_schema.sql        ← Create tables
├─ V2__seed_data.sql              ← Insert sample data
└─ V3__add_indexes.sql            ← Optimization
```

---

## 9. Database Configuration

### 9.1 Connection String

```java
public class DatabaseConnection {
    private static final String URL = "jdbc:postgresql://localhost:5432/agripos";
    private static final String USER = "postgres";
    private static final String PASSWORD = "your_password";
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
```

### 9.2 Environment Variables (Production)

```bash
# Set environment variables
export DB_HOST=localhost
export DB_PORT=5432
export DB_NAME=agripos
export DB_USER=postgres
export DB_PASSWORD=secure_password
```

---

## 10. Performance Considerations

### 10.1 Indexing Strategy
- ✅ Index pada kolom yang sering di-query (nama, kategori, tanggal)
- ✅ Index pada Foreign Keys untuk join performance

### 10.2 Query Optimization
- ✅ Gunakan `LIMIT` untuk pagination
- ✅ Hindari `SELECT *`, pilih kolom yang dibutuhkan saja
- ✅ Gunakan `EXPLAIN ANALYZE` untuk debug slow query

### 10.3 Connection Pooling (Future)
- Implementasi HikariCP untuk production
- Reuse connection untuk multiple queries

---

## 11. Security Best Practices

### 11.1 SQL Injection Prevention
- ✅ **WAJIB** menggunakan `PreparedStatement`
- ❌ **JANGAN** concatenate string untuk SQL query

**BAD:**
```java
String sql = "SELECT * FROM users WHERE username = '" + username + "'";
```

**GOOD:**
```java
String sql = "SELECT * FROM users WHERE username = ?";
ps.setString(1, username);
```

### 11.2 Password Security
- ✅ Hash password (BCrypt, SHA-256) untuk production
- ✅ Jangan simpan password plain text (kecuali untuk prototype)

---

## 12. Testing Database

### 12.1 Test Database Setup

```sql
-- Create separate test database
CREATE DATABASE agripos_test;

-- Run schema
\i database/V1__initial_schema.sql
\i database/V2__seed_data.sql
```

### 12.2 Integration Test Example

```java
@Test
public void testAddProduct() {
    // Arrange
    ProductRepository repo = new JdbcProductRepository();
    Product product = new Product("TEST001", "Test Product", "Test", 10000, 50);
    
    // Act
    repo.addProduct(product);
    
    // Assert
    Product result = repo.getProductByCode("TEST001");
    assertEquals("Test Product", result.getNama());
    
    // Cleanup
    repo.deleteProduct("TEST001");
}
```

---

## Kesimpulan

Database Agri-POS dirancang dengan:
- ✅ Normalized structure (3NF)
- ✅ Referential integrity (Foreign Keys)
- ✅ Performance optimization (Indexes)
- ✅ Security (PreparedStatement)
- ✅ Maintainability (Clear schema, versioned migrations)

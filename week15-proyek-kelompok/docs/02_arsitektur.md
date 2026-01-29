# Arsitektur Sistem Agri-POS

**Versi:** 1.0  
**Tanggal:** Januari 2026  
**Tim:** [Isi nama kelompok]

---

## 1. Overview

Agri-POS menggunakan arsitektur **Layered Architecture** dengan prinsip **Dependency Inversion Principle (DIP)** dan **SOLID principles** untuk memastikan kode yang maintainable, testable, dan scalable.

---

## 2. Layering Architecture

Sistem dibagi menjadi 5 layer utama:

```
┌─────────────────────────────────────────────┐
│          View Layer (FXML)                  │  ← JavaFX UI
├─────────────────────────────────────────────┤
│       Controller Layer                      │  ← Event Handling
├─────────────────────────────────────────────┤
│        Service Layer                        │  ← Business Logic
├─────────────────────────────────────────────┤
│      Data Access Layer (DAO)                │  ← JDBC Repository
├─────────────────────────────────────────────┤
│       Database (PostgreSQL)                 │  ← Persistence
└─────────────────────────────────────────────┘
```

---

## 3. Layer Descriptions

### 3.1 View Layer (Presentation)

**Lokasi:** `src/main/resources/fxml/`

**Tanggung Jawab:**
- Menampilkan UI kepada user
- Menerima input dari user (klik, typing, dll)
- Tidak memiliki business logic atau SQL query

**Komponen:**
- `login.fxml` - Halaman login
- `admin.fxml` - Dashboard admin (kelola produk & laporan)
- `pos.fxml` - Point of Sale kasir (transaksi)

**Aturan:**
- ❌ **DILARANG** memanggil DAO atau Database secara langsung
- ❌ **DILARANG** ada SQL query di FXML
- ✅ **BOLEH** binding dengan Controller via `fx:controller`

---

### 3.2 Controller Layer

**Lokasi:** `src/main/java/com/upb/agripos/controller/`

**Tanggung Jawab:**
- Menangani event dari View (button click, table selection, dll)
- Memanggil Service untuk eksekusi business logic
- Update UI berdasarkan response dari Service
- Validasi input dasar (tidak null, format, dll)

**Komponen:**
- `LoginController` - Handle login & routing
- `AdminController` - Handle CRUD produk & laporan
- `PosController` - Handle transaksi & checkout

**Aturan:**
- ❌ **DILARANG** memanggil DAO secara langsung
- ❌ **DILARANG** ada SQL query di Controller
- ✅ **BOLEH** memanggil Service
- ✅ **BOLEH** validasi input sederhana
- ✅ **BOLEH** menampilkan Alert/Dialog

**Contoh Flow:**
```java
@FXML
public void handleSave() {
    // 1. Ambil data dari UI
    String kode = txtKode.getText();
    
    // 2. Validasi dasar
    if (kode.isEmpty()) {
        showAlert("Kode tidak boleh kosong");
        return;
    }
    
    // 3. Panggil Service
    Product product = new Product(kode, nama, kategori, harga, stok);
    productService.add(product);
    
    // 4. Update UI
    refresh();
}
```

---

### 3.3 Service Layer (Business Logic)

**Lokasi:** `src/main/java/com/upb/agripos/`

**Tanggung Jawab:**
- Implementasi business logic dan business rules
- Orchestrasi antara berbagai DAO
- Exception handling
- Transaction management (optional)

**Komponen:**
- `ProductService` - Business logic produk
- `AuthService` - Business logic autentikasi
- `PaymentService` - Orchestrasi pembayaran
- `ReportService` - Agregasi data laporan

**Aturan:**
- ✅ **BOLEH** memanggil DAO
- ✅ **BOLEH** memanggil Service lain
- ✅ **BOLEH** validasi business rules
- ✅ **BOLEH** throw custom exception
- ❌ **DILARANG** akses UI secara langsung

**Contoh:**
```java
public class ProductService {
    private ProductRepository repo;
    
    public void add(Product p) {
        // Business rule validation
        if (p.getStok() < 0) {
            throw new ValidationException("Stok tidak boleh negatif");
        }
        
        // Delegate ke DAO
        repo.addProduct(p);
    }
}
```

---

### 3.4 Data Access Layer (DAO/Repository)

**Lokasi:** `src/main/java/com/upb/agripos/*/`

**Tanggung Jawab:**
- Akses database (CRUD operations)
- Execute SQL query menggunakan JDBC
- Mapping ResultSet ke Entity
- Error handling untuk SQLException

**Komponen:**
- `ProductRepository` (Interface)
- `JdbcProductRepository` (Implementasi)
- `TransactionRepository`

**Aturan:**
- ✅ **BOLEH** execute SQL query
- ✅ **WAJIB** menggunakan `PreparedStatement` (anti SQL Injection)
- ✅ **BOLEH** akses `DatabaseConnection`
- ❌ **DILARANG** ada business logic
- ❌ **DILARANG** akses UI

**Contoh:**
```java
public class JdbcProductRepository implements ProductRepository {
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
            e.printStackTrace();
            // Or throw custom exception
        }
    }
}
```

---

### 3.5 Database Layer

**Teknologi:** PostgreSQL

**Tanggung Jawab:**
- Menyimpan data secara persisten
- Enforce constraints (PK, FK, NOT NULL, dll)
- Indexing untuk performa query

**Tabel:**
- `users` - Data user dan role
- `products` - Master data produk
- `transactions` - Header transaksi
- `transaction_items` - Detail item transaksi

---

## 4. Package Structure

```
com.upb.agripos/
├─ AppJavaFX.java                    ← Main Application
├─ auth/
│  ├─ User.java                      ← Entity
│  └─ AuthService.java               ← Service
├─ product/
│  ├─ Product.java                   ← Entity
│  ├─ ProductRepository.java         ← Interface (DIP)
│  ├─ JdbcProductRepository.java     ← DAO Implementation
│  └─ ProductService.java            ← Service
├─ transaction/
│  ├─ Cart.java                      ← Domain Model
│  ├─ CartItem.java                  ← Domain Model
│  ├─ Transaction.java               ← Entity
│  └─ TransactionRepository.java     ← DAO
├─ payment/
│  ├─ PaymentMethod.java             ← Interface (Strategy Pattern)
│  ├─ CashPayment.java               ← Concrete Implementation
│  ├─ EWalletPayment.java            ← Concrete Implementation
│  ├─ PaymentFactory.java            ← Factory Pattern
│  └─ PaymentService.java            ← Service
├─ report/
│  └─ ReportService.java             ← Service
├─ controller/
│  ├─ LoginController.java           ← Controller
│  ├─ AdminController.java           ← Controller
│  └─ PosController.java             ← Controller
└─ util/
   └─ DatabaseConnection.java        ← Utility (Singleton Pattern)
```

---

## 5. Design Patterns

### 5.1 Strategy Pattern (Payment)

**Tujuan:** Memisahkan algoritma pembayaran agar mudah extend

```
PaymentMethod (Interface)
    ├─ CashPayment
    └─ EWalletPayment
```

**Keuntungan:**
- Open-Closed Principle: Tambah metode baru tanpa ubah kode lama
- Polymorphism: `PaymentMethod method = factory.get(type); method.pay(amount);`

---

### 5.2 Factory Pattern (PaymentFactory)

**Tujuan:** Centralize object creation

```java
public class PaymentFactory {
    public static PaymentMethod getPaymentMethod(String type) {
        return switch (type.toUpperCase()) {
            case "CASH" -> new CashPayment();
            case "EWALLET" -> new EWalletPayment();
            default -> null;
        };
    }
}
```

---

### 5.3 Singleton Pattern (DatabaseConnection)

**Tujuan:** Satu instance koneksi database (connection pool sederhana)

```java
public class DatabaseConnection {
    private static final String URL = "jdbc:postgresql://localhost:5432/agripos";
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
```

---

### 5.4 Repository Pattern (ProductRepository)

**Tujuan:** Abstraksi data access

```java
// Interface (DIP - Dependency Inversion)
public interface ProductRepository {
    void addProduct(Product p);
    List<Product> listProducts();
}

// Implementation
public class JdbcProductRepository implements ProductRepository {
    // JDBC implementation
}
```

**Keuntungan:**
- Service tidak tahu detail database
- Mudah ganti implementasi (JDBC → JPA → MongoDB)
- Mudah di-mock untuk unit testing

---

## 6. SOLID Principles Implementation

### Single Responsibility Principle (SRP)
- ✅ `ProductService` hanya handle business logic produk
- ✅ `JdbcProductRepository` hanya handle database access
- ✅ `ProductController` hanya handle UI events

### Open-Closed Principle (OCP)
- ✅ `PaymentMethod` interface memungkinkan tambah metode baru tanpa ubah kode lama

### Liskov Substitution Principle (LSP)
- ✅ Semua implementasi `PaymentMethod` bisa digunakan secara polimorfik

### Interface Segregation Principle (ISP)
- ✅ `ProductRepository` interface kecil dan fokus (tidak bloated)

### Dependency Inversion Principle (DIP)
- ✅ `ProductService` depends on `ProductRepository` (interface), bukan `JdbcProductRepository` (concrete)

---

## 7. Data Flow Example

**Contoh: Tambah Produk**

```
1. User input di admin.fxml
      ↓
2. AdminController.handleSave()
      ↓
3. ProductService.add(product)
      ↓
4. JdbcProductRepository.addProduct(product)
      ↓
5. DatabaseConnection.getConnection()
      ↓
6. PostgreSQL: INSERT INTO products
      ↓
7. Return success/error
      ↓
8. AdminController.refresh() → update tabel UI
```

---

## 8. Error Handling Strategy

### Layer-wise Error Handling:

**DAO Layer:**
- Catch `SQLException`
- Log error
- Throw custom `DatabaseException` (optional)

**Service Layer:**
- Catch business logic errors
- Throw `ValidationException`, `OutOfStockException`, dll

**Controller Layer:**
- Catch exceptions dari Service
- Tampilkan Alert ke user

---

## 9. Testing Strategy

### Unit Testing:
- ✅ Test Service layer (dengan mock DAO)
- ✅ Test domain logic (Cart, CartItem)
- ✅ Test Payment Strategy

### Integration Testing:
- ✅ Test DAO dengan database real (test database)

### Manual Testing:
- ✅ Test UI flow end-to-end

---

## 10. Scalability & Future Enhancements

### Mudah Ditambahkan:
- ✅ Metode pembayaran baru (QR Code, Credit Card) via Strategy
- ✅ Report baru (laporan bulanan, per kategori) di `ReportService`
- ✅ Fitur diskon via `DiscountStrategy`

### Potensi Refactor:
- Tambah `TransactionService` untuk orchestrasi checkout
- Pisah `ReceiptService` dari `PosController`
- Implementasi connection pooling (HikariCP)

---

## 11. Dependency Diagram

```
┌──────────────────────────────────────────┐
│          Controller Layer                │
└───────────────┬──────────────────────────┘
                │
                ↓
┌──────────────────────────────────────────┐
│           Service Layer                  │
└───────────────┬──────────────────────────┘
                │
                ↓
┌──────────────────────────────────────────┐
│         DAO/Repository Layer             │
└───────────────┬──────────────────────────┘
                │
                ↓
┌──────────────────────────────────────────┐
│         DatabaseConnection               │
└───────────────┬──────────────────────────┘
                │
                ↓
┌──────────────────────────────────────────┐
│           PostgreSQL                     │
└──────────────────────────────────────────┘
```

**Aturan Dependency:**
- Upper layer boleh memanggil lower layer
- Lower layer TIDAK BOLEH memanggil upper layer
- Dependency injection via constructor (contoh: `ProductService(ProductRepository repo)`)

---

## Kesimpulan

Arsitektur Agri-POS dirancang dengan prinsip **separation of concerns**, **SOLID principles**, dan **design patterns** yang tepat untuk memastikan sistem yang:
- ✅ Mudah dipahami (clear layering)
- ✅ Mudah di-maintain (SOLID)
- ✅ Mudah di-test (DIP, mocking)
- ✅ Mudah di-extend (OCP, Strategy)

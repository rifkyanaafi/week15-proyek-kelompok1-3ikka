# Runbook - Agri-POS

**Versi:** 1.0  
**Target:** Developer, DevOps, Support Team  
**Last Updated:** Januari 2026

---

## 1. Overview

Dokumen ini berisi panduan lengkap untuk setup, deployment, dan troubleshooting sistem Agri-POS.

---

## 2. Prerequisites

### 2.1 Software Requirements

| Software | Version | Required | Download Link |
|----------|---------|----------|---------------|
| Java JDK | 17+ | ✅ Yes | https://adoptium.net/ |
| Maven | 3.8+ | ✅ Yes | https://maven.apache.org/download.cgi |
| PostgreSQL | 14+ | ✅ Yes | https://www.postgresql.org/download/ |
| Git | Latest | ✅ Yes | https://git-scm.com/downloads |
| IDE (VS Code/IntelliJ) | Latest | 🔹 Optional | - |

### 2.2 System Requirements

**Minimum:**
- OS: Windows 10, Linux, macOS
- RAM: 4GB
- Storage: 1GB free space
- Display: 1280x720

**Recommended:**
- RAM: 8GB+
- Storage: 2GB+ free space
- Display: 1920x1080

---

## 3. Installation Guide

### 3.1 Install Java 17

**Windows:**
```powershell
# Download dari https://adoptium.net/
# Install via installer
# Verify
java -version
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install openjdk-17-jdk
java -version
```

**macOS:**
```bash
brew install openjdk@17
java -version
```

### 3.2 Install Maven

**Windows:**
```powershell
# Download dari https://maven.apache.org/download.cgi
# Extract ke C:\Program Files\Maven
# Tambahkan ke PATH: C:\Program Files\Maven\bin
# Verify
mvn -version
```

**Linux/macOS:**
```bash
# Ubuntu/Debian
sudo apt install maven

# macOS
brew install maven

# Verify
mvn -version
```

### 3.3 Install PostgreSQL

**Windows:**
```powershell
# Download installer dari https://www.postgresql.org/download/windows/
# Run installer
# Set password untuk user 'postgres'
# Verify
psql --version
```

**Linux:**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install postgresql postgresql-contrib

# Start service
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Verify
psql --version
```

**macOS:**
```bash
brew install postgresql@14
brew services start postgresql@14
psql --version
```

---

## 4. Database Setup

### 4.1 Create Database

**Step 1: Connect to PostgreSQL**
```bash
# Windows
psql -U postgres

# Linux/Mac
sudo -u postgres psql
```

**Step 2: Create Database**
```sql
CREATE DATABASE agripos;
```

**Step 3: Connect to Database**
```sql
\c agripos
```

### 4.2 Run Schema Migration

**Cara 1: Via psql**
```bash
psql -U postgres -d agripos -f database/agripos.sql
```

**Cara 2: Copy-paste manual**
1. Buka file `database/agripos.sql`
2. Copy semua content
3. Paste ke psql terminal
4. Enter

### 4.3 Verify Database

```sql
-- List all tables
\dt

-- Check data
SELECT * FROM users;
SELECT * FROM products;
SELECT * FROM transactions;
```

**Expected Output:**
```
 Schema |       Name         | Type  |  Owner   
--------+--------------------+-------+----------
 public | products           | table | postgres
 public | transaction_items  | table | postgres
 public | transactions       | table | postgres
 public | users              | table | postgres
```

---

## 5. Application Setup

### 5.1 Clone Repository

```bash
git clone <repository-url>
cd week15-proyek-kelompok
```

### 5.2 Configure Database Connection

Edit file: `src/main/java/com/upb/agripos/util/DatabaseConnection.java`

```java
public class DatabaseConnection {
    private static final String URL = "jdbc:postgresql://localhost:5432/agripos";
    private static final String USER = "postgres";
    private static final String PASSWORD = "YOUR_PASSWORD_HERE";  // ⚠️ Ganti dengan password Anda
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
```

**⚠️ PENTING:**
- Jangan commit password ke Git!
- Gunakan environment variables untuk production

### 5.3 Build Project

```bash
# Clean & compile
mvn clean compile

# Run tests (optional)
mvn test

# Package (optional)
mvn package
```

**Expected Output:**
```
[INFO] BUILD SUCCESS
[INFO] Total time: XX s
```

---

## 6. Running the Application

### 6.1 Run via Maven

```bash
mvn javafx:run
```

**Expected Behavior:**
- Console menampilkan JavaFX startup logs
- Window aplikasi terbuka dengan halaman Login

### 6.2 Run via IDE (IntelliJ IDEA)

1. Open project di IntelliJ
2. Right-click `AppJavaFX.java`
3. Select "Run 'AppJavaFX.main()'"

### 6.3 Run via JAR (Optional)

```bash
# Build JAR with dependencies
mvn clean package

# Run JAR
java -jar target/agripos-1.0-SNAPSHOT.jar
```

---

## 7. Testing & Verification

### 7.1 Smoke Test

**Test 1: Database Connection**
```bash
# Run app, check console for:
"[INFO] Koneksi Database Berhasil Terbuka"
```

**Test 2: Login**
1. Open app
2. Login dengan `admin` / `admin123`
3. Harus redirect ke Admin dashboard

**Test 3: CRUD Produk**
1. Login as Admin
2. Tambah produk test
3. Verify produk muncul di tabel

**Test 4: Transaction**
1. Login as Kasir (`kasir1` / `kasir123`)
2. Tambah produk ke keranjang
3. Checkout
4. Verify struk muncul

### 7.2 Run Unit Tests

```bash
mvn test
```

**Expected Output:**
```
Tests run: 7, Failures: 0, Errors: 0, Skipped: 0

[INFO] BUILD SUCCESS
```

---

## 8. Troubleshooting Guide

### 8.1 Issue: "Connection refused" Error

**Symptoms:**
```
java.sql.SQLException: Connection to localhost:5432 refused
```

**Solutions:**

1. **Cek PostgreSQL Service**
   ```bash
   # Windows
   services.msc → Cari PostgreSQL → Start
   
   # Linux
   sudo systemctl status postgresql
   sudo systemctl start postgresql
   
   # macOS
   brew services list
   brew services start postgresql@14
   ```

2. **Verify Port**
   ```bash
   # Check if PostgreSQL listening on port 5432
   netstat -an | grep 5432
   ```

3. **Test Connection**
   ```bash
   psql -U postgres -d agripos
   ```

---

### 8.2 Issue: "Database does not exist"

**Symptoms:**
```
org.postgresql.util.PSQLException: FATAL: database "agripos" does not exist
```

**Solutions:**

1. **Create Database**
   ```bash
   psql -U postgres -c "CREATE DATABASE agripos;"
   ```

2. **Verify**
   ```bash
   psql -U postgres -l | grep agripos
   ```

---

### 8.3 Issue: "Authentication failed for user"

**Symptoms:**
```
org.postgresql.util.PSQLException: FATAL: password authentication failed
```

**Solutions:**

1. **Reset Password**
   ```bash
   # Connect as superuser
   sudo -u postgres psql
   
   # Change password
   ALTER USER postgres PASSWORD 'new_password';
   ```

2. **Update `DatabaseConnection.java`**
   ```java
   private static final String PASSWORD = "new_password";
   ```

3. **Check `pg_hba.conf`** (Advanced)
   ```bash
   # Find config file
   psql -U postgres -c "SHOW hba_file;"
   
   # Edit (Linux)
   sudo nano /etc/postgresql/14/main/pg_hba.conf
   
   # Change 'peer' to 'md5' for local connections
   local   all   all   md5
   ```

---

### 8.4 Issue: "JavaFX runtime components are missing"

**Symptoms:**
```
Error: JavaFX runtime components are missing
```

**Solutions:**

1. **Verify `pom.xml` Dependencies**
   ```xml
   <dependency>
       <groupId>org.openjfx</groupId>
       <artifactId>javafx-controls</artifactId>
       <version>17.0.6</version>
   </dependency>
   ```

2. **Re-download Dependencies**
   ```bash
   mvn clean install -U
   ```

3. **Run with JavaFX Plugin**
   ```bash
   mvn javafx:run
   ```

---

### 8.5 Issue: "Table doesn't exist"

**Symptoms:**
```
org.postgresql.util.PSQLException: ERROR: relation "products" does not exist
```

**Solutions:**

1. **Run Schema Migration**
   ```bash
   psql -U postgres -d agripos -f database/agripos.sql
   ```

2. **Verify Tables**
   ```sql
   \c agripos
   \dt
   ```

---

### 8.6 Issue: Maven Build Fails

**Symptoms:**
```
[ERROR] Failed to execute goal
```

**Solutions:**

1. **Clean Maven Cache**
   ```bash
   mvn clean
   rm -rf ~/.m2/repository  # or delete C:\Users\<user>\.m2\repository
   mvn install
   ```

2. **Check Java Version**
   ```bash
   java -version
   mvn -version
   # Both should show Java 17+
   ```

3. **Update Maven**
   ```bash
   mvn -version
   # If < 3.8, download latest from maven.apache.org
   ```

---

## 9. Environment Variables (Production)

### 9.1 Setup Environment Variables

**Windows:**
```powershell
setx DB_HOST "localhost"
setx DB_PORT "5432"
setx DB_NAME "agripos"
setx DB_USER "postgres"
setx DB_PASSWORD "secure_password"
```

**Linux/macOS:**
```bash
export DB_HOST=localhost
export DB_PORT=5432
export DB_NAME=agripos
export DB_USER=postgres
export DB_PASSWORD=secure_password

# Add to ~/.bashrc or ~/.zshrc for persistence
echo 'export DB_HOST=localhost' >> ~/.bashrc
```

### 9.2 Update Code to Use Environment Variables

```java
public class DatabaseConnection {
    private static final String HOST = System.getenv("DB_HOST");
    private static final String PORT = System.getenv("DB_PORT");
    private static final String DB = System.getenv("DB_NAME");
    private static final String USER = System.getenv("DB_USER");
    private static final String PASSWORD = System.getenv("DB_PASSWORD");
    
    private static final String URL = String.format(
        "jdbc:postgresql://%s:%s/%s", HOST, PORT, DB
    );
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
```

---

## 10. Database Backup & Restore

### 10.1 Backup Database

```bash
# Full backup
pg_dump -U postgres -d agripos -F c -f backup_agripos_$(date +%Y%m%d).dump

# SQL format
pg_dump -U postgres -d agripos > backup_agripos_$(date +%Y%m%d).sql
```

### 10.2 Restore Database

```bash
# From custom format
pg_restore -U postgres -d agripos backup_agripos_20260129.dump

# From SQL
psql -U postgres -d agripos < backup_agripos_20260129.sql
```

### 10.3 Automated Backup (Optional)

**Linux Cron Job:**
```bash
# Edit crontab
crontab -e

# Add daily backup at 2 AM
0 2 * * * pg_dump -U postgres -d agripos -F c -f /backup/agripos_$(date +\%Y\%m\%d).dump
```

---

## 11. Deployment Checklist

### 11.1 Pre-Deployment

- [ ] Code complete & tested
- [ ] All unit tests passing (`mvn test`)
- [ ] Database schema finalized
- [ ] Seed data prepared
- [ ] Documentation complete
- [ ] Environment variables configured
- [ ] Database backup created

### 11.2 Deployment Steps

1. [ ] Clone repository to target machine
2. [ ] Install prerequisites (Java, Maven, PostgreSQL)
3. [ ] Create & configure database
4. [ ] Run schema migration
5. [ ] Configure `DatabaseConnection.java`
6. [ ] Build application (`mvn clean package`)
7. [ ] Run smoke test
8. [ ] Monitor logs for errors

### 11.3 Post-Deployment

- [ ] Verify all features working
- [ ] Train users (Admin & Kasir)
- [ ] Setup backup schedule
- [ ] Monitor system performance
- [ ] Document known issues

---

## 12. Monitoring & Logs

### 12.1 Application Logs

**Console Output:**
- Login attempts
- Database connection status
- Transaction success/failure
- SQLException details

**Enable Verbose Logging:**
```java
// Add to main method
System.setProperty("java.util.logging.config.file", "logging.properties");
```

### 12.2 Database Logs

**PostgreSQL Logs Location:**
```bash
# Linux
/var/log/postgresql/postgresql-14-main.log

# Windows
C:\Program Files\PostgreSQL\14\data\log\

# macOS
/usr/local/var/log/postgresql@14.log
```

**Query Logs:**
```sql
-- Enable query logging
ALTER SYSTEM SET log_statement = 'all';
SELECT pg_reload_conf();
```

---

## 13. Performance Tuning (Optional)

### 13.1 Database Optimization

```sql
-- Add indexes
CREATE INDEX idx_products_nama ON products(nama);
CREATE INDEX idx_transactions_tanggal ON transactions(tanggal);

-- Analyze query performance
EXPLAIN ANALYZE SELECT * FROM products WHERE nama LIKE '%pupuk%';
```

### 13.2 Connection Pooling

Consider using **HikariCP** for production:

```xml
<!-- Add to pom.xml -->
<dependency>
    <groupId>com.zaxxer</groupId>
    <artifactId>HikariCP</artifactId>
    <version>5.0.1</version>
</dependency>
```

---

## 14. Security Best Practices

### 14.1 Checklist

- [ ] Don't commit passwords to Git
- [ ] Use environment variables
- [ ] Hash passwords (BCrypt)
- [ ] Use PreparedStatement (prevent SQL Injection)
- [ ] Restrict database user privileges
- [ ] Enable SSL for database connection (production)
- [ ] Regular security updates

### 14.2 Database User Privileges

```sql
-- Create app-specific user (production)
CREATE USER agripos_app WITH PASSWORD 'secure_password';

-- Grant minimal privileges
GRANT CONNECT ON DATABASE agripos TO agripos_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO agripos_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO agripos_app;
```

---

## 15. Support & Contact

### 15.1 Quick Reference

| Issue Type | First Action |
|------------|--------------|
| App won't start | Check Java version, database connection |
| Login failed | Verify credentials in database |
| Table empty | Run seed data SQL |
| Database error | Check PostgreSQL service, logs |
| Build failed | Run `mvn clean install` |

### 15.2 Contact

**Development Team:**
- [Nama Kelompok]
- Email: [email]
- GitHub: [repository-url]

**Escalation:**
- Product Owner: [Nama Dosen]
- Email: [email dosen]

---

## 16. Appendix

### 16.1 Useful Commands

```bash
# Maven
mvn clean compile        # Compile only
mvn test                 # Run tests
mvn javafx:run          # Run app
mvn package             # Build JAR

# PostgreSQL
psql -U postgres -d agripos              # Connect
\dt                                       # List tables
\d products                               # Describe table
\q                                        # Quit

# Git
git status                                # Check status
git log --oneline                         # View commits
git pull origin main                      # Update code
```

### 16.2 Default Credentials

| Username | Password | Role |
|----------|----------|------|
| admin | admin123 | ADMIN |
| kasir1 | kasir123 | KASIR |
| kasir2 | kasir123 | KASIR |

**⚠️ Change passwords for production!**

---

**Document End**

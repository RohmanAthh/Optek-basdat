# 🐘 Optimasi Indeks PostgreSQL

<p align="center">
  <i>Bismillah, optimalkan query tanpa menguji kesabaran pengguna.</i>
</p>

<p align="center">
  <b>Belajar • Eksperimen • Analisis • Optimasi</b>
</p>

---

## 🕌 Tentang Proyek

*Assalamu’alaikum warahmatullahi wabarakatuh.*

Proyek ini merupakan eksperimen untuk mempelajari pengaruh penggunaan indeks terhadap performa query pada basis data transaksi menggunakan PostgreSQL.

Tujuannya sederhana: membantu PostgreSQL menemukan data secara lebih efisien tanpa membuat proses penulisan data ikut terasa seperti antrean panjang.

Pengujian dilakukan dengan membandingkan performa query sebelum dan sesudah penambahan indeks, kemudian menganalisis perbedaan waktu eksekusi serta rencana eksekusinya.

Sebab, dalam dunia database, **query yang berhasil dijalankan belum tentu query yang paling efisien.** Jadi, mari mengukur daripada sekadar menebak. 😌

## 🎯 Tujuan

* Memahami pengaruh indeks terhadap performa query PostgreSQL.
* Mengukur performa query sebelum optimasi (*baseline*).
* Menguji penggunaan *single-column index*, *composite index*, dan *partial index*.
* Menganalisis execution plan menggunakan `EXPLAIN ANALYZE`.
* Membandingkan waktu eksekusi dan penggunaan sumber daya.
* Menentukan strategi indeks yang sesuai dengan pola query.

## 🛠️ Teknologi

| Teknologi    | Kegunaan                                              |
| ------------ | ----------------------------------------------------- |
| PostgreSQL   | Sistem manajemen basis data                           |
| SQL          | Pembuatan skema, pengolahan data, dan pengujian query |
| DataGrip     | Menjalankan query dan menganalisis execution plan     |
| Git & GitHub | Pengelolaan versi dan dokumentasi proyek              |

## 📂 Isi Repository

| File/Folder                                  | Deskripsi                                                     |
| -------------------------------------------- | ------------------------------------------------------------- |
| `Database/Skema.sql`                         | Definisi tabel pelanggan, produk, pesanan, dan detail pesanan |
| `Database/DataDummy.sql`                     | Pembuatan data dummy untuk pengujian                          |
| `Query/BaselineQuery.sql`                    | Tiga query acuan sebelum penambahan indeks                    |
| `Script DDL Indexs/`                         | Skrip pembuatan indeks untuk eksperimen                       |
| `Composite_Indexs_Per Query.sql`             | Contoh indeks komposit untuk kebutuhan query tertentu         |
| `Composite_indexs_Status Dan Order Date.sql` | Contoh indeks komposit berdasarkan status dan tanggal pesanan |
| `Results/`                                   | Penyimpanan hasil pengujian                                   |
| `Docs/`                                      | Dokumentasi pendukung proyek                                  |

### Jenis indeks yang diuji

* **Single-column index** — indeks pada satu kolom.
* **Composite index** — indeks gabungan pada dua atau lebih kolom.
* **Partial index** — indeks yang hanya mencakup baris yang memenuhi kondisi tertentu.

Setiap jenis indeks memiliki karakteristik dan kegunaan yang berbeda. Pemilihannya perlu disesuaikan dengan kondisi pencarian dan pola query yang digunakan.

## 🔎 Skenario Pengujian

Eksperimen menggunakan tiga skenario query utama.

| No. | Skenario                                                                           | Tujuan                                              |
| --: | ---------------------------------------------------------------------------------- | --------------------------------------------------- |
|   1 | Riwayat pesanan pelanggan tertentu                                                 | Menguji pencarian pesanan berdasarkan pelanggan     |
|   2 | Penjualan produk pada pesanan berstatus `completed` dalam rentang tanggal tertentu | Menguji filter status, tanggal, dan analisis produk |
|   3 | Pesanan berstatus `pending` yang berumur lebih dari tujuh hari                     | Menguji pencarian berdasarkan status dan tanggal    |

Ketiga skenario digunakan sebagai acuan untuk membandingkan performa query pada kondisi sebelum dan sesudah optimasi.

## ⚙️ Alur Pengujian

```text
       ┌─────────────────────┐
       │ Membuat Skema DB    │
       └──────────┬──────────┘
                  ▼
       ┌─────────────────────┐
       │ Mengisi Data Dummy  │
       └──────────┬──────────┘
                  ▼
       ┌─────────────────────┐
       │ Menjalankan Baseline│
       └──────────┬──────────┘
                  ▼
       ┌─────────────────────┐
       │ Menganalisis Query  │
       └──────────┬──────────┘
                  ▼
       ┌─────────────────────┐
       │ Menerapkan Indeks   │
       └──────────┬──────────┘
                  ▼
       ┌─────────────────────┐
       │ Menguji Ulang Query │
       └──────────┬──────────┘
                  ▼
       ┌─────────────────────┐
       │ Membandingkan Hasil │
       └─────────────────────┘
```

## 🚀 Cara Menggunakan

### 1. Siapkan database

Pastikan PostgreSQL sudah terpasang dan layanan database berjalan.

Buat database khusus untuk eksperimen agar tidak mengganggu data penting.

```sql
CREATE DATABASE ecommerce_benchmark;
```

### 2. Buat struktur tabel

Jalankan skrip berikut melalui DataGrip atau klien PostgreSQL lainnya:

```text
Database/Skema.sql
```

Pastikan seluruh tabel berhasil dibuat sebelum melanjutkan.

### 3. Masukkan data dummy

Jalankan:

```text
Database/DataDummy.sql
```

Periksa jumlah baris pada setiap tabel untuk memastikan data sudah siap digunakan.

### 4. Jalankan query baseline

Buka dan jalankan:

```text
Query/BaselineQuery.sql
```

Catat waktu eksekusi dan simpan execution plan untuk setiap query sebelum optimasi.

### 5. Terapkan indeks

Pilih skrip indeks yang ingin diuji dari:

```text
Script DDL Indexs/
```

Untuk eksperimen yang menggunakan file indeks komposit, periksa juga skrip yang tercantum pada bagian isi repository.

### 6. Jalankan ulang query

Jalankan kembali query yang sama dengan parameter dan dataset yang setara.

Simpan hasilnya di folder `Results/` agar dapat dibandingkan dengan hasil baseline.

### 7. Analisis hasil

Bandingkan waktu eksekusi, strategi akses data, dan statistik buffer untuk mengevaluasi dampak indeks.

> **Catatan kecil:** Simpan hasil baseline sebelum membuat indeks eksperimen. Kalau tidak, pembandingnya bisa ikut berubah. Niat sudah benar, jangan sampai datanya malah bikin bingung. 😄

## 📊 Analisis Performa

Untuk melihat rencana eksekusi dan statistik aktual, gunakan:

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM orders
WHERE customer_id = 1001;
```

Contoh tersebut merupakan ilustrasi penggunaan `EXPLAIN ANALYZE`. Sesuaikan query dan nilai pencarian dengan skenario pengujian yang sebenarnya.

### Metrik yang diamati

| Metrik           | Keterangan                                                       |
| ---------------- | ---------------------------------------------------------------- |
| `Execution Time` | Waktu eksekusi aktual query                                      |
| `Planning Time`  | Waktu yang digunakan untuk merencanakan query                    |
| `Scan Type`      | Strategi akses data, misalnya sequential scan atau index scan    |
| `Buffers`        | Informasi aktivitas buffer selama eksekusi                       |
| `Actual Rows`    | Jumlah baris aktual yang diproses pada suatu node execution plan |

### Menghitung pengurangan waktu eksekusi

Persentase pengurangan waktu eksekusi dapat dihitung menggunakan rumus:

$$
\text{Pengurangan Waktu (\%)} =
\frac{T_{\text{baseline}}-T_{\text{optimasi}}}
{T_{\text{baseline}}}\times100\%
$$

Keterangan:

* \(T_{\text{baseline}}\): waktu eksekusi sebelum optimasi.
* \(T_{\text{optimasi}}\): waktu eksekusi setelah optimasi.

Nilai positif menunjukkan pengurangan waktu eksekusi. Hasil aktual tetap perlu diukur karena pengaruh indeks bergantung pada query, distribusi data, statistik tabel, konfigurasi PostgreSQL, dan kondisi mesin.

## ⚠️ Catatan Penting

* Jalankan seluruh eksperimen pada database pengujian.
* Periksa skrip sebelum menjalankan perintah yang menghapus atau mengubah data.
* Gunakan dataset dan parameter yang setara saat membandingkan hasil.
* Ulangi pengukuran jika memungkinkan untuk mengurangi pengaruh variasi waktu eksekusi.
* Jangan menganggap indeks selalu meningkatkan performa.
* Pertimbangkan kebutuhan penyimpanan dan biaya pemeliharaan indeks saat data berubah.
* Cantumkan hasil pengukuran aktual dalam laporan; jangan mengisi kesimpulan berdasarkan perkiraan.

**Ingat:** indeks bukan jimat. Tidak semua query otomatis menjadi cepat hanya karena indeksnya bertambah. Terkadang yang perlu diperbaiki adalah pola query-nya, bukan jumlah indeksnya. 😂

## 📚 Referensi

* [Dokumentasi PostgreSQL](https://www.postgresql.org/docs/)
* [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/current/sql-explain.html)
* [PostgreSQL — Indexes](https://www.postgresql.org/docs/current/indexes.html)
* [PostgreSQL — Using EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html)

## 🤲 Penutup

*Wassalamu’alaikum warahmatullahi wabarakatuh.*

Semoga eksperimen ini menambah pemahaman tentang pengelolaan basis data dan pentingnya pengujian performa yang terukur.

Terus belajar, terus mencoba, dan jangan mudah menyerah ketika query belum sesuai harapan. Setiap hasil pengujian adalah bahan evaluasi untuk menjadi lebih baik.

**Bismillah, semoga query semakin efisien, database tetap sehat, dan deadline memberikan sedikit kelonggaran. Aamiin.** 🐘

# Tugas Besar UAS Big Data  
## Implementasi Pipeline ETL dan ELT menggunakan PostgreSQL

---

## Deskripsi Proyek

Repositori ini berisi implementasi **pipeline ETL (Extract–Transform–Load)** dan **ELT (Extract–Load–Transform)** sebagai bagian dari **Tugas Besar UAS Mata Kuliah Big Data**.  
Proyek ini disusun dan diimplementasikan sesuai dengan ketentuan pada dokumen resmi:

- **TUGAS BESAR UAS BIG DATA.pdf**
- **LAPORAN TUGAS BESAR BIG DATA.docx**

Pendekatan **ETL dan ELT** digunakan secara bersamaan untuk menunjukkan pemahaman konseptual dan perbedaan implementasi antara kedua metode tersebut, dengan **PostgreSQL sebagai data warehouse utama**.

---

## Struktur Direktori

```
UAS/
│
├─ architecture/
│  ├─ architecture_diagram_elt.png
│  └─ architecture_diagram_etl.png
│
├─ dashboard/
│  ├─ dashboard_link.txt
│  └─ readme.md
│
├─ datalake/
│   ├─ source1/
│   |  └─ Pakistans Largest E-Commerce Dataset.csv 
│   └─ source2/
│      └─ pakistan_holiday.csv
│
├─ elt_pipeline/
│   ├─ load_raw.sql
│   ├─ transform_elt.sql
│   └─ aggregation.sql
│
├─ etl_pipeline/
│  ├─ duplicate_data.ipynb
│  └─ etl_pipeline.ipynb
│
├─ logs/
│   ├─ elt_pipeline/
│   │  └─ extract_elt.py
│`  ├─ etl_extract.log
│   ├─ elt_extract.log
│   └─ README.md
│
├─ raw/
│   ├─ source1/
│   │   └─ ecommerce_raw.csv
│   └─ source2/
│       └─ holiday_raw.csv
│
├─ visualization/
│   └─ visualisasi.ipynb
│
├─ warehouse/
│   ├─ README.md
│   └─ schema_structure.sql
│
└─ readme.md
```

Struktur direktori ini dirancang untuk memisahkan data mentah, proses ETL/ELT, logging, data warehouse, dan visualisasi sesuai praktik rekayasa data.

---

## Dataset

### Source 1 – Dataset Utama
- **Pakistan’s Largest E-Commerce Dataset**
- Format: CSV  
- Berisi data transaksi e-commerce seperti order, pelanggan, metode pembayaran, dan waktu transaksi.

### Source 2 – Dataset Pendukung
- **Pakistan Holiday Dataset**
- Format: CSV  
- Berisi data hari libur nasional Pakistan.

Kedua dataset memiliki **format tanggal dan struktur data yang berbeda**, sehingga memerlukan proses transformasi dan standardisasi.

---

## Pipeline ETL (Extract – Transform – Load)

Pipeline **ETL** digunakan untuk menunjukkan pendekatan klasik pengolahan data, dengan tahapan:

1. **Extract**  
   Data diambil dari masing-masing sumber data.

2. **Transform**  
   Data dibersihkan dan distandardisasi sebelum dimuat, termasuk:
   - Handling missing value
   - Standarisasi format data
   - Penyesuaian tipe data

3. **Load**  
   Data hasil transformasi dimuat ke target sistem.

Pendekatan ETL ini digunakan sebagai pembanding konseptual terhadap ELT sesuai dengan ketentuan tugas.

---

## Pipeline ELT (Extract – Load – Transform)

Pipeline utama yang diimplementasikan pada proyek ini adalah **ELT**, dengan tahapan berikut:

### 1. Extract
- Dilakukan menggunakan script Python (`extract_elt.py`)
- Mengambil data dari **dua sumber berbeda**
- Tidak melakukan cleaning atau transformasi
- Data mentah disimpan dalam format CSV
- Proses extract dicatat dalam file log

### 2. Load
- Data mentah dimuat langsung ke PostgreSQL
- Disimpan pada schema `raw`
- Proses load dilakukan menggunakan `load_raw.sql`
- Tidak ada perubahan struktur atau isi data

### 3. Transform (di Data Warehouse)
Seluruh transformasi dilakukan **setelah data berada di PostgreSQL**, meliputi:
- Data cleaning (missing value, duplikasi, inkonsistensi)
- Standardisasi tipe data dan format tanggal
- Normalisasi kolom numerik
- Encoding dan standarisasi kolom kategorikal
- Join antar sumber data
- Feature engineering
- Agregasi analitik

Transformasi diimplementasikan dalam:
- `transform_elt.sql`
- `aggregation.sql`

Pendekatan ini menegaskan perbedaan ELT dengan ETL, di mana transformasi dilakukan di sisi data warehouse.

---

## Arsitektur Data Warehouse

PostgreSQL digunakan sebagai data warehouse dengan pembagian schema:
- **raw**: data mentah hasil load
- **staging**: data hasil cleaning dan standardisasi
- **mart**: data hasil join, feature engineering, dan agregasi

Struktur schema terdokumentasi pada folder `warehouse/`.

---

## Feature Engineering dan Agregasi

Beberapa fitur baru yang dihasilkan:
- Indikator hari libur (`is_holiday`)
- Kategori hari (`weekday`, `weekend`, `holiday`)
- Segmentasi nilai transaksi
- Masa keanggotaan pelanggan (customer tenure)
- Kunci waktu (year–month)

Agregasi analitik mencakup:
- Tren penjualan bulanan
- Perbandingan hari libur vs non-libur
- Analisis jenis hari
- Segmentasi nilai transaksi
- Segmentasi pelanggan berdasarkan tenure

---

## Logging

Proses extract dicatat pada:
```
logs/elt_pipeline/elt_extract.log
```

Log berisi informasi:
- Nama sumber data
- Jumlah baris dan kolom
- Ukuran data
- Waktu eksekusi extract

---

Pendekatan ELT dipilih sebagai metode utama karena lebih fleksibel dalam menangani data dengan format dan kualitas yang beragam, sementara ETL digunakan sebagai pembanding konsep.
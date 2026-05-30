# 📖 API Documentation — Hana's Cake E-Commerce

**Base URL:** `https://hanascake.syauqiebill.my.id/api`
**Authentication:** Laravel Sanctum (Bearer Token)
**Content-Type:** `application/json`

---

## 🔑 Authentication

Semua endpoint **Protected** memerlukan header:

```
Authorization: Bearer {token}
```

Token didapatkan dari response endpoint `/register` atau `/login`.

---

## 📋 Daftar Endpoint

| #   | Method | Endpoint                   | Auth | Deskripsi                 |
| --- | ------ | -------------------------- | ---- | ------------------------- |
| 1   | POST   | `/register`                | ❌   | Registrasi pelanggan baru |
| 2   | POST   | `/login`                   | ❌   | Login pelanggan           |
| 3   | POST   | `/logout`                  | ✅   | Logout (revoke token)     |
| 4   | GET    | `/profile`                 | ✅   | Ambil data profil         |
| 5   | POST   | `/profile/update`          | ✅   | Update profil + avatar    |
| 6   | POST   | `/change-password`         | ✅   | Ganti password            |
| 7   | GET    | `/categories`              | ❌   | Daftar kategori           |
| 8   | GET    | `/products`                | ❌   | Daftar produk             |
| 9   | GET    | `/products/{id}`           | ❌   | Detail produk             |
| 10  | GET    | `/stores`                  | ❌   | Daftar toko aktif         |
| 11  | POST   | `/checkout`                | ✅   | Proses checkout           |
| 12  | GET    | `/orders`                  | ✅   | Riwayat pesanan           |
| 13  | GET    | `/orders/{id}`             | ✅   | Detail pesanan            |
| 14  | POST   | `/pin/setup`               | ✅   | Atur PIN pembayaran       |
| 15  | POST   | `/pin/verify`              | ✅   | Verifikasi PIN            |
| 16  | GET    | `/addresses`               | ✅   | Daftar alamat             |
| 17  | POST   | `/addresses`               | ✅   | Tambah alamat             |
| 18  | PUT    | `/addresses/{id}`          | ✅   | Edit alamat               |
| 19  | DELETE | `/addresses/{id}`          | ✅   | Hapus alamat              |
| 20  | PATCH  | `/addresses/{id}/primary`  | ✅   | Set alamat utama          |
| 21  | GET    | `/notifications`           | ✅   | Daftar notifikasi         |
| 22  | POST   | `/notifications/{id}/read` | ✅   | Tandai dibaca             |
| 23  | POST   | `/midtrans/webhook`        | ❌   | Webhook Midtrans          |

---

## 1. Auth — Register

**`POST /api/register`** — Rate limited: 5 req/menit

### Request Body

```json
{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123",
    "phone": "081234567890"
}
```

### Response Sukses (201)

```json
{
    "success": true,
    "message": "Registrasi Berhasil",
    "data": {
        "user": {
            "id": 1,
            "name": "John Doe",
            "email": "john@example.com",
            "role": "pelanggan",
            "phone": "081234567890"
        },
        "token": "1|abc123xyz..."
    }
}
```

### Response Gagal (422)

```json
{
    "success": false,
    "message": "Validasi gagal",
    "errors": {
        "email": ["Email sudah terdaftar."],
        "password": ["Password minimal 8 karakter."]
    }
}
```

---

## 2. Auth — Login

**`POST /api/login`** — Rate limited: 5 req/menit

### Request Body

```json
{
    "email": "john@example.com",
    "password": "password123"
}
```

### Response Sukses (200)

```json
{
    "success": true,
    "message": "Login Berhasil",
    "data": {
        "user": {
            "id": 1,
            "name": "John Doe",
            "email": "john@example.com",
            "role": "pelanggan"
        },
        "token": "2|xyz789abc..."
    }
}
```

### Response Gagal (401)

```json
{ "success": false, "message": "Email atau Password salah" }
```

### Response Gagal (403) — Role bukan pelanggan

```json
{
    "success": false,
    "message": "Akses ditolak. Aplikasi ini khusus untuk Pelanggan."
}
```

---

## 3. Auth — Logout

**`POST /api/logout`** 🔒

### Response Sukses (200)

```json
{ "success": true, "message": "Logout Berhasil" }
```

---

## 4. Auth — Profile

**`GET /api/profile`** 🔒

### Response Sukses (200)

```json
{
    "success": true,
    "message": "Data Profil Berhasil Diambil",
    "data": {
        "id": 1,
        "name": "John Doe",
        "email": "john@example.com",
        "phone": "081234567890",
        "address": "Jl. Contoh No. 1",
        "city": "Makassar",
        "birth_date": "2000-01-15",
        "gender": "male",
        "avatar_url": "http://127.0.0.1:8000/storage/avatars/abc123.jpg"
    }
}
```

---

## 5. Auth — Update Profile

**`POST /api/profile/update`** 🔒 — Content-Type: `multipart/form-data`

### Request Body (form-data)

| Field       | Type   | Required | Keterangan                           |
| ----------- | ------ | -------- | ------------------------------------ |
| name        | string | ✅       | Nama lengkap                         |
| email       | string | ✅       | Email (unik)                         |
| phone       | string | ❌       | No. telepon                          |
| address     | string | ❌       | Alamat                               |
| city        | string | ❌       | Kota                                 |
| postal_code | string | ❌       | Kode pos                             |
| birth_date  | date   | ❌       | Tanggal lahir (YYYY-MM-DD)           |
| gender      | string | ❌       | `male` atau `female`                 |
| avatar      | file   | ❌       | Foto profil (JPG/PNG/WEBP, maks 2MB) |

### Response Sukses (200)

```json
{
    "success": true,
    "message": "Profil berhasil diperbarui",
    "data": {
        "id": 1,
        "name": "John Doe Updated",
        "avatar_url": "http://127.0.0.1:8000/storage/avatars/new123.jpg"
    }
}
```

---

## 6. Auth — Change Password

**`POST /api/change-password`** 🔒

### Request Body

```json
{
    "current_password": "oldpassword123",
    "new_password": "newpassword456",
    "new_password_confirmation": "newpassword456"
}
```

### Response Sukses (200)

```json
{ "success": true, "message": "Password berhasil diubah" }
```

### Response Gagal (401)

```json
{ "success": false, "message": "Password lama tidak sesuai" }
```

---

## 7. Kategori

**`GET /api/categories`**

### Response Sukses (200)

```json
{
    "success": true,
    "message": "Daftar Kategori",
    "data": [
        { "id": 1, "name": "Kue Ulang Tahun", "slug": "kue-ulang-tahun" },
        { "id": 2, "name": "Pastry", "slug": "pastry" }
    ]
}
```

---

## 8. Produk — Daftar

**`GET /api/products`** — Supports pagination, filter & search

### Query Parameters

| Param       | Type   | Keterangan                   |
| ----------- | ------ | ---------------------------- |
| category_id | int    | Filter berdasarkan kategori  |
| search      | string | Cari berdasarkan nama produk |
| page        | int    | Halaman (default: 1)         |

### Contoh: `GET /api/products?category_id=1&search=coklat&page=1`

### Response Sukses (200)

```json
{
    "success": true,
    "message": "Daftar Produk",
    "data": {
        "current_page": 1,
        "data": [
            {
                "id": 1,
                "name": "Kue Coklat Premium",
                "price": 150000,
                "discount": 10,
                "stock": 5,
                "image_url": "http://...",
                "category": { "id": 1, "name": "Kue Ulang Tahun" }
            }
        ],
        "last_page": 3,
        "per_page": 10,
        "total": 25
    }
}
```

---

## 9. Produk — Detail

**`GET /api/products/{id}`**

### Response Sukses (200)

```json
{
    "success": true,
    "message": "Detail Produk",
    "data": {
        "id": 1,
        "name": "Kue Coklat Premium",
        "price": 150000,
        "discount": 10,
        "description": "Kue coklat lembut...",
        "flavors": ["Coklat", "Vanilla"],
        "portions": ["Small", "Medium"],
        "category": { "id": 1, "name": "Kue Ulang Tahun" }
    }
}
```

### Response Gagal (404)

```json
{ "success": false, "message": "Produk tidak ditemukan" }
```

---

## 10. Toko

**`GET /api/stores`**

### Response Sukses (200)

```json
{
    "success": true,
    "message": "Daftar toko berhasil diambil",
    "data": [
        {
            "id": 1,
            "name": "Hana's Cake Pusat",
            "address": "Jl. Pettarani No. 10",
            "latitude": -5.1477,
            "longitude": 119.4327,
            "open_time": "08:00",
            "close_time": "21:00",
            "is_active": true
        }
    ]
}
```

---

## 11. Checkout

**`POST /api/checkout`** 🔒

### Request Body

```json
{
    "delivery_type": "delivery",
    "store_id": 1,
    "address_id": 2,
    "total_belanja": 300000,
    "items": [{ "product_id": 1, "quantity": 2, "price": 150000 }],
    "notes": "Topping extra coklat"
}
```

| Field         | Type    | Required | Keterangan                                  |
| ------------- | ------- | -------- | ------------------------------------------- |
| delivery_type | string  | ✅       | `pickup` atau `delivery`                    |
| store_id      | int     | ✅       | ID toko (untuk semua tipe)                  |
| address_id    | int     | ✅\*     | Wajib jika `delivery`                       |
| total_belanja | numeric | ✅       | Total harga belanja (belum termasuk ongkir) |
| items         | array   | ✅       | Minimal 1 item                              |
| notes         | string  | ❌       | Catatan pesanan                             |

> **⚠️ Catatan Ongkir:** `total_belanja` adalah subtotal produk saja (tanpa ongkir). Ongkir dihitung **otomatis oleh backend** berdasarkan jarak antara `address_id` dan `store_id`. Flutter **tidak perlu** mengirim field ongkir.

### Perhitungan Ongkir Otomatis

| Tipe          | Kondisi Jarak   | Ongkir                         |
| ------------- | --------------- | ------------------------------ |
| `pickup`      | —               | Rp 0 (gratis)                  |
| `delivery`    | ≤ 1 km          | Rp 2.000                       |
| `delivery`    | 1 – 10 km       | `ceil(jarak) × Rp 2.000`      |
| `delivery`    | > 10 km         | ❌ Ditolak (error 500)         |
| `delivery`    | Koordinat kosong| Rp 0 (tidak bisa dihitung)     |

**Contoh:** Jarak 3.2 km → `ceil(3.2) = 4` → Ongkir = `4 × 2.000` = **Rp 8.000**

### Response Sukses (200)

```json
{
    "success": true,
    "message": "Checkout Berhasil",
    "data": {
        "order_id": 15,
        "snap_token": "66e4fa55-fdac-4ef5-bcab-95c305d...",
        "shipping_cost": 8000,
        "grand_total": 308000
    }
}
```

| Field Response  | Keterangan                                          |
| --------------- | --------------------------------------------------- |
| order_id        | ID order yang dibuat                                |
| snap_token      | Token Midtrans untuk halaman pembayaran             |
| shipping_cost   | Ongkir yang dihitung otomatis (Rp)                  |
| grand_total     | Total akhir: `total_belanja` + `shipping_cost` (Rp) |

### Response Gagal — Validasi (422)

```json
{
    "success": false,
    "message": "Validasi gagal",
    "errors": { "store_id": ["Toko wajib dipilih."] }
}
```

### Response Gagal — Di Luar Jangkauan (500)

```json
{
    "success": false,
    "message": "Checkout gagal: Lokasi pengiriman di luar jangkauan (jarak: 12.5 km, maks: 10 km). Silakan ganti alamat atau pilih metode pickup."
}
```

---

## 12–13. Orders

**`GET /api/orders`** 🔒 — Riwayat pesanan

```json
{
  "success": true,
  "message": "Daftar Riwayat Pesanan",
  "data": [
    {
      "id": 15,
      "total": "300000.00",
      "status": "diproses",
      "payment_status": "paid",
      "delivery_type": "pickup",
      "tanggal": "2026-05-19T14:00:00.000000Z",
      "queue_number": "015",
      "distance": 19.48,
      "store_details": {
        "id": 1,
        "name": "Hana's Cake Pusat",
        "address": "Jl. Pettarani No. 10",
        "latitude": -5.1477,
        "longitude": 119.4327
      },
      "items": [...]
    }
  ]
}
```

**`GET /api/orders/{id}`** 🔒 — Detail pesanan (termasuk items + produk, queue_number, distance, & store_details)

---

## 14–15. PIN Pembayaran

**`POST /api/pin/setup`** 🔒

```json
{ "pin": "123456", "password": "akun_password" }
```

**`POST /api/pin/verify`** 🔒

```json
{ "pin": "123456" }
```

| Response  | Code | Message                                  |
| --------- | ---- | ---------------------------------------- |
| Sukses    | 200  | PIN valid, silakan lanjutkan checkout.   |
| Gagal     | 401  | PIN tidak valid                          |
| Belum set | 403  | PIN belum diatur (`require_setup: true`) |

---

## 16–20. Alamat Pelanggan

**`GET /api/addresses`** 🔒

```json
{
    "success": true,
    "message": "Daftar alamat berhasil diambil",
    "data": [
        {
            "id": 1,
            "customer_id": 1,
            "title": "Rumah",
            "detail_address": "Jl. Pettarani No.10, Makassar",
            "latitude": "-5.14770000",
            "longitude": "119.43270000",
            "receiver_name": "John Doe",
            "receiver_phone": "081234567890",
            "is_primary": 1,
            "created_at": "2026-05-29T09:50:52.000000Z",
            "updated_at": "2026-05-29T09:50:52.000000Z"
        }
    ]
}
```

---

**`POST /api/addresses`** 🔒 — Tambah alamat baru

### Request Body

```json
{
    "title": "Kantor",
    "detail_address": "Jl. AP Pettarani No. 20, Makassar",
    "latitude": -5.15,
    "longitude": 119.435,
    "receiver_name": "John Doe",
    "receiver_phone": "081234567890",
    "is_primary": false
}
```

| Field          | Type    | Required | Keterangan                                  |
| -------------- | ------- | -------- | ------------------------------------------- |
| title          | string  | ✅       | Label alamat: Rumah, Kantor, dll (maks 100) |
| detail_address | string  | ✅       | Alamat lengkap (maks 500)                   |
| receiver_name  | string  | ✅       | Nama penerima (maks 255)                    |
| receiver_phone | string  | ✅       | No HP penerima (maks 20)                    |
| latitude       | numeric | ❌       | -90 s/d 90                                  |
| longitude      | numeric | ❌       | -180 s/d 180                                |
| is_primary     | boolean | ❌       | Default false. Alamat pertama otomatis primary |

> **⚠️ Penting:** Pastikan key JSON **persis** seperti tabel di atas. Menggunakan key berbeda (misal `label` alih-alih `title`, atau `address` alih-alih `detail_address`) akan menyebabkan error validasi 422.

---

**`PUT /api/addresses/{id}`** 🔒 — Edit alamat (body sama seperti POST)

**`DELETE /api/addresses/{id}`** 🔒 — Hapus alamat

> Jika yang dihapus adalah alamat primary, alamat terbaru otomatis dijadikan primary baru.

**`PATCH /api/addresses/{id}/primary`** 🔒 — Set sebagai alamat utama

> Method: **PATCH** (bukan POST/PUT). Tanpa request body. Semua alamat lain otomatis di-reset menjadi non-primary.

---

## 21–22. Notifikasi

**`GET /api/notifications`** 🔒 — Query: `?unread_only=true`

```json
{
    "success": true,
    "data": {
        "data": [
            {
                "id": "uuid-123",
                "type": "order_status",
                "title": "Update Pesanan #HANA-ONL-ABC123",
                "message": "Pesanan sedang diproses",
                "order_id": 15,
                "read_at": null,
                "created_at": "2026-05-19T14:00:00"
            }
        ]
    }
}
```

**`POST /api/notifications/{id}/read`** 🔒

---

## 23. Midtrans Webhook

**`POST /api/midtrans/webhook`** — Dipanggil oleh server Midtrans

> ⚠️ Endpoint ini TIDAK memerlukan autentikasi Bearer Token.
> Keamanan dijamin oleh verifikasi signature SHA-512.

---

## 🔴 Kode Error Standar

| HTTP Code | Arti              | Kapan Muncul                   |
| --------- | ----------------- | ------------------------------ |
| 200       | OK                | Request berhasil               |
| 201       | Created           | Data baru berhasil dibuat      |
| 400       | Bad Request       | Input tidak valid              |
| 401       | Unauthorized      | Token salah / password salah   |
| 403       | Forbidden         | Tidak punya akses (role salah) |
| 404       | Not Found         | Data tidak ditemukan           |
| 422       | Unprocessable     | Validasi gagal                 |
| 429       | Too Many Requests | Rate limit terlampaui          |
| 500       | Server Error      | Error internal server          |

---

## 📁 Environment Variables (.env)

```env
# Midtrans Payment Gateway
MIDTRANS_SERVER_KEY=Mid-server-xxxxx
MIDTRANS_CLIENT_KEY=Mid-client-xxxxx
MIDTRANS_IS_PRODUCTION=false
MIDTRANS_MERCHANT_ID=Gxxxxx

# Mail (untuk verifikasi email)
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=465
MAIL_USERNAME=your@gmail.com
MAIL_PASSWORD="app-password"
MAIL_ENCRYPTION=ssl
```
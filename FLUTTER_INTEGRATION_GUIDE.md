# 📱 Flutter Mobile Integration Guide — Hana's Cake

Panduan ini ditujukan untuk **Mobile Developer (Flutter)** yang akan mengintegrasikan aplikasi mobile dengan backend API Hana's Cake.

## 🔗 Referensi API

Seluruh detail endpoint (URL, Request Body, Response) sudah didokumentasikan secara lengkap pada file:
👉 **[`API_DOCUMENTATION.md`](./API_DOCUMENTATION.md)**

Silakan rujuk file tersebut untuk struktur request/response tiap endpoint. Panduan di bawah ini difokuskan pada _best practices_ implementasi di sisi Flutter.

---

## 🛠️ Stack & Packages Rekomendasi

Untuk mempermudah integrasi, sangat disarankan menggunakan package berikut pada project Flutter:

1.  **HTTP Client:** `dio` atau `http` (Disarankan `dio` karena fitur interceptor bawaan lebih mudah digunakan untuk handle token).
2.  **State Management:** `GetX`, `Bloc`, atau `Provider` (sesuai kenyamanan tim).
3.  **Local Storage:** `shared_preferences` atau `flutter_secure_storage` (untuk menyimpan Bearer Token secara aman).
4.  **JSON Serialization:** `json_serializable` dan `json_annotation` (atau `freezed`).

---

## 🔐 Manajemen Autentikasi (Bearer Token)

API ini menggunakan **Laravel Sanctum**. Setiap endpoint yang diberi label 🔒 pada `API_DOCUMENTATION.md` WAJIB menyertakan header `Authorization: Bearer {token}`.

### Alur Autentikasi:

1.  **Login (`/api/login`)**: Kirim email & password. Jika sukses, API akan mengembalikan `data.token`.
2.  **Simpan Token**: Simpan token ini ke local storage (misal: `flutter_secure_storage`).
3.  **Gunakan Interceptor**: Buat `Dio Interceptor` yang akan secara otomatis menyisipkan token ke setiap request yang membutuhkan autentikasi.
4.  **Logout (`/api/logout`)**: Panggil endpoint logout, lalu hapus token dari local storage dan arahkan user kembali ke halaman Login.
5.  **Handle 401 (Unauthorized)**: Jika interceptor menerima response `401`, berarti token expired atau tidak valid. Hapus token dari storage dan paksa user ke halaman Login.

### Contoh Implementasi Interceptor (menggunakan Dio)

```dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://hanascake.syauqiebill.my.id/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Ambil token dari storage
          const storage = FlutterSecureStorage();
          final token = await storage.read(key: 'auth_token');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            // TODO: Handle Token Expired (Clear storage & redirect to Login)
          }
          return handler.next(e);
        },
      ),
    );
}
```

---

## 📂 Saran Struktur Folder (Clean Architecture / Feature-Based)

Untuk menjaga kode tetap rapi, gunakan struktur berbasis fitur:

```text
lib/
 ├── core/                  # Utilities, Constants, Network Client (Dio setup)
 │    ├── network/          # ApiClient, Interceptors
 │    ├── theme/            # Colors, Typography
 │    └── utils/            # Formatters (Currency, Date)
 ├── data/                  # Layer Komunikasi dengan API
 │    ├── models/           # Class Model (ProductModel, UserModel, dll)
 │    └── repositories/     # Class Repository (memanggil endpoint)
 ├── features/              # Halaman / Fitur Aplikasi
 │    ├── auth/             # Login, Register, Lupa Password
 │    ├── home/             # Tampilan Home, Daftar Produk, Toko
 │    ├── cart_checkout/    # Keranjang & Checkout
 │    ├── order/            # Riwayat & Detail Pesanan
 │    └── profile/          # Profil User, Ubah Password, Alamat
 └── main.dart              # Entry Point
```

---

## 🛒 Flow Penting: Checkout & Pembayaran

Sistem checkout terintegrasi dengan **Midtrans**. Berikut adalah alur (flow) yang harus diimplementasikan di Flutter:

1.  User memilih produk dan masuk ke halaman Checkout.
2.  User memilih tipe pesanan (`pickup` atau `delivery`) dan alamat (jika delivery).
3.  Aplikasi memanggil endpoint **`POST /api/checkout`**.
4.  Jika sukses, API akan mengembalikan `snap_token`.
5.  Gunakan `snap_token` ini di sisi mobile untuk menampilkan halaman pembayaran Midtrans.
    *   **Rekomendasi:** Gunakan package `midtrans_sdk` (jika tersedia dan stabil) ATAU gunakan `webview_flutter` untuk memuat URL Snap Midtrans (`https://app.sandbox.midtrans.com/snap/v2/vtweb/` + `snap_token`).
6.  Setelah pembayaran selesai di Midtrans, backend Laravel akan menerima Webhook secara otomatis dan mengubah status pesanan. Mobile app cukup melakukan *pull-to-refresh* atau polling ringan di halaman Riwayat Pesanan untuk melihat perubahan status.

---

## 💡 Tips & Trik Tambahan

1.  **Format Rupiah**: Gunakan package `intl` (`NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ')`) untuk memformat harga yang dikembalikan dari API.
2.  **Pagination**: Endpoint `/api/products` mendukung pagination. Terapkan _Infinite Scrolling_ di ListView menggunakan data `current_page` dan `last_page` dari API.
3.  **Upload Gambar**: Untuk update profil (avatar), pastikan mengirim data menggunakan `FormData` (Multipart), bukan JSON biasa.
4.  **Handling Error**: API ini menggunakan format error standar Laravel (status `422 Unprocessable Entity` untuk error validasi). Tangkap `e.response.data['errors']` untuk menampilkan pesan error di form (misal: "Email sudah digunakan").

## 📞 Bantuan

Jika terdapat ketidaksesuaian antara dokumentasi dan response API, silakan hubungi tim Backend / Fullstack.

# 📱 Flutter API Integration — Hana's Cake E-Commerce

Folder ini berisi semua file Dart yang dibutuhkan programmer Flutter
untuk terhubung dengan backend Laravel website Hana's Cake.

**Base URL API:** `https://hanascake.syauqiebill.my.id/api`  
**Autentikasi:** Laravel Sanctum (Bearer Token)

---

## 📁 Struktur File

```
flutter_api/
├── pubspec.yaml                    ← Dependencies yang diperlukan
├── CONTOH_PENGGUNAAN.dart          ← Contoh kode lengkap (baca ini dulu!)
├── README_FLUTTER.md               ← Panduan ini
└── lib/
    ├── hanas_cake_api.dart         ← 🔑 Import satu baris (barrel export)
    ├── constants/
    │   └── api_constants.dart      ← URL & endpoint constants
    ├── models/
    │   ├── api_response.dart       ← Generic response wrapper & ApiException
    │   ├── user_model.dart         ← Model User/Profile
    │   ├── product_model.dart      ← Model Produk, Kategori, PaginatedProducts
    │   ├── order_model.dart        ← Model Order, Store, CheckoutRequest
    │   └── address_notification_model.dart  ← Model Alamat & Notifikasi
    └── services/
        ├── api_client.dart         ← HTTP client terpusat (token management)
        ├── auth_service.dart       ← Register, Login, Logout, Profile
        ├── product_service.dart    ← Katalog produk & kategori
        ├── order_service.dart      ← Toko, Checkout, Riwayat pesanan
        ├── address_pin_service.dart ← CRUD Alamat & PIN pembayaran
        └── notification_service.dart ← Notifikasi
```

---

## ⚙️ Cara Integrasi ke Project Flutter

### Step 1: Tambahkan Dependencies

Di `pubspec.yaml` project Flutter kamu, tambahkan:

```yaml
dependencies:
  http: ^1.2.0
  shared_preferences: ^2.2.3
```

Lalu jalankan:
```bash
flutter pub get
```

### Step 2: Salin Folder `lib/` ke Project Flutter

Salin folder `lib/` ke dalam project Flutter kamu, misalnya ke:
```
your_flutter_app/lib/api/
```

Sehingga strukturnya jadi:
```
your_flutter_app/
└── lib/
    ├── api/
    │   ├── hanas_cake_api.dart
    │   ├── constants/
    │   ├── models/
    │   └── services/
    └── main.dart
```

### Step 3: Import dan Gunakan

```dart
import 'package:your_app/api/hanas_cake_api.dart';

// Login
final result = await AuthService.instance.login(
  email: 'user@email.com',
  password: 'password123',
);
```

---

## 🔧 Konfigurasi URL

Edit file `lib/constants/api_constants.dart`:

```dart
// Untuk Android Emulator (development)
static const String baseUrl = 'http://10.0.2.2:8000/api';

// Untuk iOS Simulator (development)
static const String baseUrl = 'http://localhost:8000/api';

// Untuk Production
static const String baseUrl = 'https://hanascake.syauqiebill.my.id/api';
```

---

## 📋 Daftar Endpoint & Service

| Endpoint | Method | Auth | Service | Method |
|----------|--------|------|---------|--------|
| `/register` | POST | ❌ | `AuthService` | `register()` |
| `/login` | POST | ❌ | `AuthService` | `login()` |
| `/logout` | POST | ✅ | `AuthService` | `logout()` |
| `/profile` | GET | ✅ | `AuthService` | `getProfile()` |
| `/profile/update` | POST | ✅ | `AuthService` | `updateProfile()` |
| `/change-password` | POST | ✅ | `AuthService` | `changePassword()` |
| `/categories` | GET | ❌ | `ProductService` | `getCategories()` |
| `/products` | GET | ❌ | `ProductService` | `getProducts()` |
| `/products/{id}` | GET | ❌ | `ProductService` | `getProductDetail()` |
| `/stores` | GET | ❌ | `StoreService` | `getStores()` |
| `/checkout` | POST | ✅ | `OrderService` | `checkout()` |
| `/orders` | GET | ✅ | `OrderService` | `getOrders()` |
| `/orders/{id}` | GET | ✅ | `OrderService` | `getOrderDetail()` |
| `/pin/setup` | POST | ✅ | `PinService` | `setupPin()` |
| `/pin/verify` | POST | ✅ | `PinService` | `verifyPin()` |
| `/addresses` | GET | ✅ | `AddressService` | `getAddresses()` |
| `/addresses` | POST | ✅ | `AddressService` | `addAddress()` |
| `/addresses/{id}` | PUT | ✅ | `AddressService` | `updateAddress()` |
| `/addresses/{id}` | DELETE | ✅ | `AddressService` | `deleteAddress()` |
| `/addresses/{id}/primary` | PATCH | ✅ | `AddressService` | `setPrimaryAddress()` |
| `/notifications` | GET | ✅ | `NotificationService` | `getNotifications()` |
| `/notifications/{id}/read` | POST | ✅ | `NotificationService` | `markAsRead()` |

---

## 🚦 Error Handling

Semua error dilempar sebagai `ApiException`:

```dart
try {
  final result = await AuthService.instance.login(
    email: 'test@email.com',
    password: 'wrong',
  );
} on ApiException catch (e) {
  switch (e.statusCode) {
    case 401:
      print('Email/password salah atau token expired');
      break;
    case 403:
      print('Akses ditolak (bukan pelanggan / PIN belum setup)');
      break;
    case 422:
      print('Validasi gagal: ${e.errorMessage}');
      break;
    case 429:
      print('Terlalu banyak request, tunggu 1 menit');
      break;
    case 500:
      print('Server error, coba lagi nanti');
      break;
    default:
      print('Error: ${e.message}');
  }
}
```

---

## 💳 Integrasi Midtrans (Pembayaran)

Setelah checkout berhasil, kamu mendapatkan `snap_token`.
Gunakan token ini dengan package Midtrans Flutter:

```bash
# Tambahkan ke pubspec.yaml
midtrans_sdk: ^2.2.0
```

```dart
final result = await OrderService.instance.checkout(request);
final snapToken = result['snap_token'];

// Tampilkan Midtrans payment page
MidtransSDK.instance.startPaymentUiFlow(token: snapToken);
```

---

## 📌 Catatan Penting

1. **Token disimpan otomatis** di SharedPreferences setelah login/register
2. **Token dihapus otomatis** saat logout
3. **Rate limiting**: Endpoint `/register` dan `/login` maks 5 request/menit
4. **Upload avatar**: Gunakan `image_picker` package untuk memilih foto, lalu kirim `File` ke `updateProfile()`
5. **Checkout PIN**: Selalu verifikasi PIN sebelum checkout
6. **Pagination produk**: Default 10 item per halaman, gunakan `page` parameter

---

## 🔗 Kontak Developer Backend

Jika ada kendala integrasi, hubungi developer backend website Hana's Cake.

**Base URL Production:** `https://hanascake.syauqiebill.my.id`  
**Tech Stack:** Laravel 11, Sanctum Auth, Midtrans Payment Gateway

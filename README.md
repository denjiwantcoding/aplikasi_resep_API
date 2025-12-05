# 📚 Aplikasi Resep Masakan

Aplikasi mobile modern untuk menemukan dan menyimpan resep masakan favorit Anda. Dibangun dengan Flutter dan menggunakan data dari TheMealDB API.

## 📖 Penjelasan Aplikasi

**Aplikasi Resep Masakan** adalah aplikasi mobile yang memudahkan pengguna untuk:

- 🔍 **Mencari resep** - Cari ribuan resep masakan dari seluruh dunia
- 📂 **Jelajahi kategori** - Telusuri resep berdasarkan kategori (Beef, Chicken, Dessert, Seafood, dll)
- ⭐ **Simpan favorit** - Tandai resep favorit untuk akses cepat
- 📝 **Lihat detail lengkap** - Bahan-bahan, instruksi memasak, dan informasi nutrisi
- 🎥 **Video tutorial** - Link ke video YouTube untuk panduan visual
- 🌍 **Filter berdasarkan area** - Temukan resep dari berbagai negara (Italian, Chinese, Indian, dll)
- 🎲 **Resep random** - Dapatkan inspirasi dengan resep acak
- 🌙 **Dark mode** - Tema gelap untuk kenyamanan mata

### Fitur Utama

#### 1. Beranda (Home)
- Pencarian resep dengan keyword
- Kategori resep dalam bentuk horizontal scroll
- Resep terpopuler
- Tombol akses cepat ke "Semua Resep" dan "Semua Kategori"

#### 2. Semua Resep
- Daftar lengkap resep dari A-Z
- Pencarian real-time
- Loading progresif untuk UX yang lebih baik

#### 3. Semua Kategori
- Grid view kategori dengan icon unik
- Warna berbeda untuk setiap kategori
- Tap untuk melihat resep dalam kategori

#### 4. Detail Resep
- Gambar resep berkualitas tinggi
- Daftar bahan-bahan lengkap dengan takaran
- Instruksi memasak step-by-step
- Tag dan area asal resep
- Link ke video tutorial YouTube
- Tombol favorite untuk menyimpan resep

#### 5. Favorit
- Daftar resep yang telah disimpan
- Persistent storage (tersimpan meskipun aplikasi ditutup)
- Akses cepat ke resep favorit

#### 6. Pengaturan
- Toggle dark mode / light mode
- Informasi aplikasi

## 🔌 Daftar Endpoint API yang Digunakan

Aplikasi ini menggunakan **TheMealDB API** (https://www.themealdb.com/api.php)

### 1. Search & Lookup

| Endpoint | Deskripsi | Implementasi |
|----------|-----------|--------------|
| `GET /search.php?s={query}` | Cari resep berdasarkan nama | ✅ Fitur pencarian |
| `GET /search.php?f={letter}` | Cari resep berdasarkan huruf pertama | ✅ Load semua resep A-Z |
| `GET /lookup.php?i={id}` | Ambil detail resep berdasarkan ID | ✅ Detail lengkap resep |
| `GET /random.php` | Ambil 1 resep random | ✅ Resep random di home |

### 2. Categories & Filters

| Endpoint | Deskripsi | Implementasi |
|----------|-----------|--------------|
| `GET /categories.php` | Daftar semua kategori | ✅ Grid kategori |
| `GET /filter.php?c={category}` | Filter resep berdasarkan kategori | ✅ Resep per kategori |
| `GET /filter.php?a={area}` | Filter resep berdasarkan area/negara | ✅ Available |
| `GET /filter.php?i={ingredient}` | Filter resep berdasarkan bahan | ✅ Available |

### 3. Lists

| Endpoint | Deskripsi | Implementasi |
|----------|-----------|--------------|
| `GET /list.php?c=list` | Daftar semua kategori | ✅ |
| `GET /list.php?a=list` | Daftar semua area | ✅ |
| `GET /list.php?i=list` | Daftar semua bahan | ✅ |

### Response Format

API mengembalikan data dalam format JSON:

```json
{
  "meals": [
    {
      "idMeal": "52772",
      "strMeal": "Teriyaki Chicken Casserole",
      "strCategory": "Chicken",
      "strArea": "Japanese",
      "strInstructions": "...",
      "strMealThumb": "https://www.themealdb.com/images/media/meals/...",
      "strTags": "Meat,Casserole",
      "strYoutube": "https://www.youtube.com/watch?v=...",
      "strIngredient1": "soy sauce",
      "strMeasure1": "3/4 cup",
      ...
    }
  ]
}
```

## 🚀 Cara Instalasi

### Prasyarat

Pastikan Anda telah menginstal:
- **Flutter SDK** (versi 3.0 atau lebih baru)
- **Dart SDK** (versi 3.9.2 atau lebih baru)
- **Android Studio** atau **VS Code** dengan Flutter extension
- **Git**

### Langkah Instalasi

#### 1. Clone Repository

```bash
git clone <repository-url>
cd aplikasi_resep
```

#### 2. Install Dependencies

```bash
flutter pub get
```

#### 3. Jalankan Aplikasi

##### Untuk Android:
```bash
# Pastikan device Android terhubung atau emulator sudah berjalan
flutter run
```

##### Untuk iOS (hanya di macOS):
```bash
# Buka iOS simulator
open -a Simulator

# Jalankan aplikasi
flutter run
```

##### Untuk Web:
```bash
flutter run -d chrome
```

#### 4. Build APK (Android)

```bash
# Debug APK
flutter build apk

# Release APK
flutter build apk --release

# APK akan tersimpan di: build/app/outputs/flutter-apk/
```

#### 5. Build App Bundle (untuk Google Play Store)

```bash
flutter build appbundle --release
```

### Troubleshooting

#### Gradle Cache Error
Jika mengalami error cache Gradle:
```bash
# Hapus cache Gradle
Remove-Item -Path "D:\.gradle\caches" -Recurse -Force

# Atau di Linux/Mac
rm -rf ~/.gradle/caches

# Clean project
flutter clean
flutter pub get
```

#### Build Error
```bash
# Clean dan rebuild
flutter clean
flutter pub get
flutter run
```

#### Dependency Conflict
```bash
# Update dependencies
flutter pub upgrade
```

## 📦 Dependencies

Aplikasi ini menggunakan package berikut:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  provider: ^6.1.2              # State management
  shared_preferences: ^2.3.1    # Local storage
  http: ^1.2.0                  # HTTP requests
  url_launcher: ^6.3.0          # Launch URLs (YouTube)

dev_dependencies:
  flutter_test:
    sdk: flutter
  network_image_mock: ^2.1.1
  flutter_lints: ^5.0.0
```

## 📱 Screenshots

### Home Screen
- Pencarian resep
- Kategori horizontal scroll
- Resep terpopuler

### All Categories
- Grid kategori dengan icon
- Warna unik per kategori

### Recipe Detail
- Gambar full-width
- Bahan & instruksi
- Link YouTube

### Favorites
- Daftar resep favorit
- Empty state

## 🏗️ Struktur Project

```
lib/
├── main.dart                 # Entry point
├── core/
│   ├── app_routes.dart      # Route configuration
│   └── theme.dart           # App theme
├── models/
│   └── recipe_model.dart    # Recipe data model
├── providers/
│   └── recipe_provider.dart # State management
├── services/
│   └── meal_api_service.dart # API calls
├── screens/
│   ├── home_screen.dart
│   ├── all_recipes_screen.dart
│   ├── all_categories_screen.dart
│   ├── recipe_list_screen.dart
│   ├── recipe_detail_screen.dart
│   ├── favorites_screen.dart
│   └── settings_screen.dart
├── widgets/
│   ├── recipe_card.dart
│   ├── category_card.dart
│   └── search_bar.dart
├── data/
│   ├── dummy_data.dart      # Fallback data
│   └── local_storage.dart   # SharedPreferences helper
└── utils/
    ├── image_helpers.dart
    └── theme.dart
```

## 🛠️ Teknologi yang Digunakan

- **Framework**: Flutter 3.x
- **Language**: Dart 3.9.2
- **State Management**: Provider
- **HTTP Client**: http package
- **Local Storage**: SharedPreferences
- **API**: TheMealDB API
- **Architecture**: MVVM (Model-View-ViewModel)


## 👨‍💻 Developer

Dibuat dengan untuk tugas Praktikum Mobile Programming



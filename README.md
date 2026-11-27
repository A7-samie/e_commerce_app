# 🛍️ E-Commerce App

A fully functional **E-Commerce mobile application** built with **Flutter**, featuring a clean UI and smooth user experience using the **Cubit** state management pattern.

---

## 📱 Screenshots

> _Add your app screenshots here_

---

## ✨ Features

- 🔐 **Authentication** — User Registration & Login with form validation
- 🏠 **Home Screen** — Browse products fetched from a live REST API
- 📦 **Product Listing** — Display products with images, names, and prices
- 🔍 **Product Details** — Detailed view for each product
- 🛒 **Shopping Cart** — Add/remove items and view total price
- 👤 **User Profile** — View and manage account info

---

## 🛠️ Tech Stack

| Technology | Usage |
|---|---|
| **Flutter** | UI Framework |
| **Dart** | Programming Language |
| **Cubit (Bloc)** | State Management |
| **REST API** | Fetching Products Data |
| **HTTP Package** | API Calls |
| **Flutter Bloc** | Cubit Integration |

---

## 📂 Project Structure

```
lib/
├── core/
│   ├── api/          # API service & endpoints
│   └── utils/        # Helper functions
├── features/
│   ├── auth/         # Login & Register screens + Cubit
│   ├── home/         # Home screen + Cubit
│   ├── products/     # Product listing & details + Cubit
│   └── cart/         # Cart screen + Cubit
└── main.dart
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart >= 3.0.0

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/A7-samie/e_commerce_app.git

# 2. Navigate to project directory
cd e_commerce_app

# 3. Install dependencies
flutter pub get

# 4. Run the app
flutter run
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  http: ^1.1.0
  cached_network_image: ^3.3.0
```

---

## 🔗 API

This app fetches product data from a public REST API. Products are displayed dynamically with real-time data loading and error handling.

---

## 👨‍💻 Author

**A7-samie**  
GitHub: [@A7-samie](https://github.com/A7-samie)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

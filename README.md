# In-App WebView App with GetX

This Flutter project demonstrates how to package a public website inside an in-app WebView, 
using the [GetX](https://pub.dev/packages/get) package for state management and navigation. 
It targets the site [https://the-internet.herokuapp.com/](https://the-internet.herokuapp.com/) and supports 
features like file upload/download and JavaScript alerts out of the box.

---

## 🚀 Features

- 🌐 Displays a full web browser inside your Flutter app.
- 📤 File upload and 📥 download and Geolocation support.
- 🧠 Custom JavaScript alerts using GetX dialogs.
- 🛠️ Proper error handling and back navigation.
- 🔐 Bonus: Handles HTTP Basic Authentication requests.

---

## 🛠️ How it Works

- Uses [`flutter_inappwebview`](https://pub.dev/packages/flutter_inappwebview) for advanced WebView embedding.
- All navigation and state management is done using GetX controllers and observables.
- JavaScript alert events are intercepted and displayed using GetX's dialog system.
- File downloads are launched externally using the [`url_launcher`](https://pub.dev/packages/url_launcher) package.
- The app structure is clean and modular, making it easy to maintain and extend.

---

## 🏁 Getting Started

Follow the steps below to run the project locally:

### 1. Clone the Repository

```bash
git clone https://github.com/uveshmansuri/in_app_webview_full.git
cd in_app_webview_full
```

### 2. Install Dependencies
```bash 
flutter pub get
```

### 3. Run the App
```bash
flutter run
```

---

## How GetX is Used

* State Management: All webview state (loading, error, controller, etc) is managed by a WebViewGetxController extending GetxController.

* UI Reactivity: The UI updates via Obx widgets.

* Navigation/Dialogs: All navigation and dialogs are handled with GetX, ensuring loosely-coupled architecture.

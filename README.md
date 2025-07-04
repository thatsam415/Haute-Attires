# Haute Attires – Setup Guide

This project includes:

- `haute_attires/` – Flutter frontend application
- `api_haute_attires/` – PHP backend (API files)
- `haute_attires.sql` – MySQL database file
- `demo_video.mp4` – Demo of the project functionality

---

## 🛠 Prerequisites

- Flutter SDK installed
- XAMPP (Apache + MySQL)
- VS Code (recommended)

---

## 🚀 Setup Instructions

### 1. Download & Place Folders

- Place the `haute_attires` folder anywhere on your system (e.g., Documents, Desktop).
- Copy the `api_haute_attires` folder and place it inside the `htdocs` directory of your XAMPP installation.

### 2. Import Database

- Open `phpMyAdmin` from the XAMPP control panel.
- Create a new database (e.g., `haute_attires_db`).
- Import the `haute_attires.sql` file into this database.

### 3. Run the Project

- Open **both** folders (`haute_attires/` and `api_haute_attires/`) in VS Code.
- Start your **XAMPP server**: Enable both Apache and MySQL.

#### Flutter Setup

- In the `haute_attires` folder, run `flutter pub get` to install dependencies from `pubspec.yaml`.
- Open any Dart file inside the `lib/` folder (e.g., `main.dart`).
- Run the project using VS Code or terminal:  
  ```bash
  flutter run


#### Happy coding!
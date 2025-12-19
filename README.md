# 🚴‍♂️ Delivery Boy App (Flutter)

A Flutter-based mobile application for delivery executives to manage assigned orders, track live location, and complete deliveries efficiently.

This project is created as a **machine test / interview assignment**, focusing on clean architecture, API integration, and real-world delivery flow.

---

## 📱 App Overview

The **Delivery Boy App** enables a delivery executive to:

- Log in using a mobile number (OTP-based)
- View assigned delivery orders
- See current location on Google Maps
- Navigate to customer delivery locations
- Mark orders as delivered
- View delivery history
- Manage profile and logout

---

## ✨ Features

### 🔐 Authentication
- Mobile number login
- OTP verification  
  **Static OTP for testing:** `123456`
- Login session stored locally using `shared_preferences`

---

### 📦 Orders
- Orders fetched from REST API (mock backend)
- Displays only **assigned / pending orders**
- Order details include:
  - Customer name, address, phone number
  - Product list with quantities & prices
  - Delivery time and distance
- Mark order as **Delivered**
- Delivered orders automatically move to **Order History**

---

### 🧭 Maps & Location
- Shows **delivery boy’s current live location**
- Displays **customer delivery location** on Google Maps
- Markers for:
  - Delivery boy
  - Customer destination
- Location fetched using `geolocator`
- Map rendered using `google_maps_flutter`

<sub>
ℹ️ Route drawing and turn-by-turn navigation can be enabled using Google Directions API.  
Billing is required to enable this API, so the current implementation focuses on live location tracking, markers, and navigation readiness.
</sub>

---

### 📜 Order History
- Displays all completed deliveries
- Shows delivered date and time
- Data filtered based on `status: "delivered"`

---

### 👤 Profile
- View and update profile information
- Logout functionality
- Profile data stored locally

---

## 🛠️ Tech Stack

- **Flutter** – Cross-platform UI
- **Dart** – Programming language
- **google_maps_flutter** – Map integration
- **geolocator** – Live location tracking
- **mockapi.io** – Mock REST backend
- **shared_preferences** – Local storage

---

## 🔗 Mock Backend Setup (mockapi.io)

The app uses **mockapi.io** as a mock backend to simulate real APIs.

### Resources
- `auth`
- `orders`

### Base API URL
```text
https://<your-project-id>.mockapi.io/api/v1/


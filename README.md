# 🚴‍♂️ Delivery Boy App (Flutter)

A Flutter-based mobile application for delivery boys to view assigned orders, navigate to delivery locations, and mark orders as delivered.  
This project is built for **machine test / assignment purposes** using a mock backend.

---

## 🌑 Dark Mode Support

- The app supports dark mode! The appearance automatically adapts to match your system-wide light or dark theme settings.

## 🍔 What does this app do?

- Login using **mobile number + OTP** (mock OTP: `123456`)
- View list of **assigned (active) orders**
- View full order details:
  - Customer name, address, phone
  - Ordered products
  - Delivery time & amount
- Show **delivery boy’s current location on map**
- Navigate from **current location to customer address**
- Mark order as **Delivered**
- View **Order History** (delivered orders)
- Profile tab with logout

---

## 🛠️ Tech Stack

- **Flutter** – UI & app logic
- **mockapi.io** – Mock backend (REST API)
- **google_maps_flutter** – Map display
- **geolocator** – Current location
- **http** – API calls
- **shared_preferences** – Local session storage

---

## 🔑 App Flow

1. User logs in with phone number  
2. OTP verification (mocked)
3. Orders fetched from MockAPI.io
4. Active orders shown in Home screen
5. Delivered orders shown in History screen
6. Order status updated using API (`PUT`)

---

## 🌐 MockAPI.io Setup

### Step 1: Create MockAPI Project
1. Go to https://mockapi.io
2. Sign up (free)
3. Create a new project

### Step 2: Create Resources

Create **two resources**:

#### 🔹 Resource 1: `auth`
Fields:
- `phoneNumber` (String)
- `otp` (String)
- `token` (String)
- `timestamp` (String)

Used only for mock authentication.

---

#### 🔹 Resource 2: `orders`
Fields:
- `orderId` (String)
- `customerName` (String)
- `customerAddress` (String)
- `customerPhone` (String)
- `deliveryTime` (String – ISO 8601)
- `distance` (Number)
- `latitude` (Number)
- `longitude` (Number)
- `status` (String: `assigned`, `delivered`)
- `totalAmount` (Number)
- `specialInstructions` (String / null)
- `products` (Array of objects)

---

## 🛒 Sample Orders JSON (MockAPI.io)

Paste this **entire array** inside **orders → Resource Data** in MockAPI.io:

```json
[
  {
    "id": "ORD007",
    "orderId": "ORD007",
    "customerName": "John Doe man",
    "customerAddress": "123 Main Street, City Center, 12345",
    "customerPhone": "+1234567890",
    "deliveryTime": "2025-01-15T14:30:00Z",
    "distance": 2.5,
    "latitude": 28.6139,
    "longitude": 77.209,
    "status": "assigned",
    "totalAmount": 35.97,
    "specialInstructions": "Please ring the doorbell twice",
    "products": [
      {
        "id": "1",
        "name": "Pizza Margherita",
        "quantity": 2,
        "price": 12.99
      },
      {
        "id": "2",
        "name": "Coca Cola",
        "quantity": 2,
        "price": 2.5
      },
      {
        "id": "3",
        "name": "Garlic Bread",
        "quantity": 1,
        "price": 4.99
      }
    ]
  },
  {
    "id": "ORD008",
    "orderId": "ORD008",
    "customerName": "Jane Smith",
    "customerAddress": "456 Park Avenue, Downtown, 67890",
    "customerPhone": "+1234567891",
    "deliveryTime": "2025-01-15T16:00:00Z",
    "distance": 5.3,
    "latitude": 28.7041,
    "longitude": 77.1025,
    "status": "assigned",
    "totalAmount": 34.96,
    "specialInstructions": null,
    "products": [
      {
        "id": "4",
        "name": "Burger Deluxe",
        "quantity": 1,
        "price": 15.99
      },
      {
        "id": "5",
        "name": "French Fries",
        "quantity": 2,
        "price": 5.99
      },
      {
        "id": "6",
        "name": "Milkshake",
        "quantity": 1,
        "price": 6.99
      }
    ]
  },
  {
    "id": "ORD009",
    "orderId": "ORD009",
    "customerName": "Robert Johnson",
    "customerAddress": "789 Oak Road, Suburb, 54321",
    "customerPhone": "+1234567892",
    "deliveryTime": "2025-01-15T18:00:00Z",
    "distance": 8.7,
    "latitude": 28.5355,
    "longitude": 77.391,
    "status": "assigned",
    "totalAmount": 56.92,
    "specialInstructions": "Leave at the front door",
    "products": [
      {
        "id": "7",
        "name": "Chicken Biryani",
        "quantity": 2,
        "price": 18.99
      },
      {
        "id": "8",
        "name": "Naan Bread",
        "quantity": 4,
        "price": 3.99
      },
      {
        "id": "9",
        "name": "Mango Lassi",
        "quantity": 2,
        "price": 4.99
      }
    ]
  },
  {
    "id": "ORD010",
    "orderId": "ORD010",
    "customerName": "Emily Davis",
    "customerAddress": "321 Elm Street, Uptown, 98765",
    "customerPhone": "+1234567893",
    "deliveryTime": "2025-01-15T15:45:00Z",
    "distance": 3.2,
    "latitude": 28.6129,
    "longitude": 77.2295,
    "status": "assigned",
    "totalAmount": 35.96,
    "specialInstructions": "Call before arrival",
    "products": [
      {
        "id": "10",
        "name": "Sushi Platter",
        "quantity": 1,
        "price": 24.99
      },
      {
        "id": "11",
        "name": "Miso Soup",
        "quantity": 2,
        "price": 3.99
      },
      {
        "id": "12",
        "name": "Green Tea",
        "quantity": 1,
        "price": 2.99
      }
    ]
  },
  {
    "id": "ORD005",
    "orderId": "ORD005",
    "customerName": "Michael Brown",
    "customerAddress": "654 Pine Lane, Midtown, 11111",
    "customerPhone": "+1234567894",
    "deliveryTime": "2025-01-15T17:15:00Z",
    "distance": 6.1,
    "latitude": 28.6448,
    "longitude": 77.2167,
    "status": "delivered",
    "totalAmount": 42.96,
    "specialInstructions": null,
    "products": [
      {
        "id": "13",
        "name": "Pad Thai",
        "quantity": 2,
        "price": 14.99
      },
      {
        "id": "14",
        "name": "Spring Rolls",
        "quantity": 1,
        "price": 7.99
      },
      {
        "id": "15",
        "name": "Thai Iced Tea",
        "quantity": 2,
        "price": 4.99
      }
    ],
    "deliveredAt": "2025-12-19T12:38:25.885741"
  },
  {
    "id": "ORD011",
    "orderId": "ORD011",
    "customerName": "Sophia Wilson",
    "customerAddress": "987 Maple Street, Green Park, 22222",
    "customerPhone": "+1234567895",
    "deliveryTime": "2025-01-15T19:30:00Z",
    "distance": 9.4,
    "latitude": 28.4595,
    "longitude": 77.0266,
    "status": "assigned",
    "totalAmount": 29.98,
    "specialInstructions": "Deliver to security gate",
    "products": [
      {
        "id": "16",
        "name": "Veggie Wrap",
        "quantity": 2,
        "price": 8.99
      },
      {
        "id": "17",
        "name": "Orange Juice",
        "quantity": 2,
        "price": 3.99
      }
    ]
  }
]
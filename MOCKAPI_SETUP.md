# MockAPI.io Setup Guide

This app uses MockAPI.io for backend API endpoints. Follow these steps to set up your MockAPI.io project.

## Step 1: Create a MockAPI.io Account

1. Go to https://mockapi.io/
2. Sign up for a free account
3. Create a new project

## Step 2: Get Your Project ID

1. After creating a project, you'll see your project ID in the URL or dashboard
2. Example: If your project URL is `https://1234567890abcdef.mockapi.io`, then your project ID is `1234567890abcdef`

## Step 3: Update API Configuration

1. Open `lib/config/api_config.dart`
2. Replace `'your-project-id'` with your actual MockAPI.io project ID

```dart
static const String baseUrl = 'https://YOUR-PROJECT-ID.mockapi.io/api/v1';
```

## Step 4: Create API Resources in MockAPI.io

You need to create the following resources in your MockAPI.io project:

### 1. Auth Resource (`/auth`)

Create a resource named `auth` with the following fields:
- `phoneNumber` (String)
- `otp` (String, optional)
- `token` (String, optional)
- `timestamp` (String, optional)

**Endpoints:**
- `POST /auth/send-otp` - Send OTP to phone number
- `POST /auth/verify-otp` - Verify OTP and return token

### 2. Orders Resource (`/orders`)

Create a resource named `orders` with the following fields:
- `orderId` (String)
- `customerName` (String)
- `customerAddress` (String)
- `customerPhone` (String)
- `deliveryTime` (String - ISO 8601 format)
- `distance` (Number)
- `latitude` (Number, optional)
- `longitude` (Number, optional)
- `status` (String - values: "pending", "assigned", "inTransit", "delivered", "cancelled")
- `totalAmount` (Number)
- `specialInstructions` (String, optional)
- `products` (Array of objects)

**Product Object Structure:**
- `id` (String)
- `name` (String)
- `quantity` (Number)
- `price` (Number)
- `imageUrl` (String, optional)

**Endpoints:**
- `GET /orders` - Get all orders
- `GET /orders/:id` - Get order by ID
- `PUT /orders/:id` - Update order (for marking as delivered)

## Step 5: Sample Data Structure

### Sample Order JSON:

```json
{
  "orderId": "ORD001",
  "customerName": "John Doe",
  "customerAddress": "123 Main Street, City Center, 12345",
  "customerPhone": "+1234567890",
  "deliveryTime": "2024-01-15T14:30:00Z",
  "distance": 2.5,
  "latitude": 28.6139,
  "longitude": 77.2090,
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
      "price": 2.50
    },
    {
      "id": "3",
      "name": "Garlic Bread",
      "quantity": 1,
      "price": 4.99
    }
  ]
}
```

### Sample Auth Response (Verify OTP):

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "phoneNumber": "+1234567890"
}
```

## Step 6: Testing

1. Add some sample orders to your MockAPI.io `/orders` resource
2. Test the authentication flow
3. Verify that orders are fetched correctly
4. Test marking orders as delivered

## Notes

- The app includes fallback dummy data if the API fails
- Mock OTP `123456` will still work as a fallback for testing
- All API calls include error handling with fallback to local data
- Delivered orders are tracked both in the API and locally

## API Endpoints Summary

- `POST /api/v1/auth/send-otp` - Send OTP
- `POST /api/v1/auth/verify-otp` - Verify OTP
- `GET /api/v1/orders` - Get all orders
- `GET /api/v1/orders/:id` - Get order by ID
- `PUT /api/v1/orders/:id` - Update order status


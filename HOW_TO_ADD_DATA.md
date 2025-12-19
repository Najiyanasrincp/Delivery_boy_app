# How to Add Data to MockAPI.io

## Understanding the Data Flow

**Current Situation:**
- Your app calls: `https://6944e4617dd335f4c36187ef.mockapi.io/api/v1/orders`
- If MockAPI.io has NO data → Returns empty array `[]`
- If MockAPI.io HAS data → Returns that data
- If API call FAILS → Uses dummy data from code

## Step-by-Step: Adding Orders to MockAPI.io

### Method 1: Using MockAPI.io Dashboard (Easiest)

1. **Go to your MockAPI.io project:**
   - Visit: https://mockapi.io/projects
   - Click on your project (ID: `6944e4617dd335f4c36187ef`)

2. **Create/Check the `orders` resource:**
   - Look for a resource named `orders`
   - If it doesn't exist, click "New Resource" → Name it `orders`

3. **Add an order manually:**
   - Click on the `orders` resource
   - Click "New Item" or "Add"
   - Fill in the fields (see sample JSON below)

### Method 2: Using API Directly (Programmatic)

You can add data using POST requests:

```bash
POST https://6944e4617dd335f4c36187ef.mockapi.io/api/v1/orders
Content-Type: application/json

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
    }
  ]
}
```

### Method 3: Using Browser/Postman

1. Open Postman or any API client
2. Set method to `POST`
3. URL: `https://6944e4617dd335f4c36187ef.mockapi.io/api/v1/orders`
4. Headers: `Content-Type: application/json`
5. Body: Use the JSON above
6. Send request

## Sample Order JSON Structure

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

## How to Check What Data Exists

### Option 1: Check in Browser
Visit: `https://6944e4617dd335f4c36187ef.mockapi.io/api/v1/orders`

- If you see `[]` → No data exists
- If you see JSON array → Data exists

### Option 2: Check in MockAPI.io Dashboard
- Go to your project dashboard
- Click on `orders` resource
- See list of all orders

## Current Behavior After Update

✅ **If MockAPI.io has data:**
- App fetches and displays API data

✅ **If MockAPI.io is empty (returns `[]`):**
- App automatically uses dummy data from code

✅ **If API call fails (network error):**
- App uses dummy data from code

## Quick Test

1. **Test with empty API:**
   - Visit: `https://6944e4617dd335f4c36187ef.mockapi.io/api/v1/orders`
   - Should show `[]` if empty
   - App will show dummy data

2. **Add one order via MockAPI dashboard:**
   - Add order manually
   - Refresh app
   - Should see your API order

3. **Add multiple orders:**
   - Add 2-3 orders
   - Refresh app
   - Should see all API orders

## Troubleshooting

**Q: App shows no orders?**
- Check if MockAPI.io has data: Visit the API URL in browser
- Check network connection
- Check if API URL is correct

**Q: App shows dummy data instead of API data?**
- MockAPI.io might be empty → Add data using methods above
- API might be failing → Check network/URL

**Q: How do I know if API is working?**
- Open browser: `https://6944e4617dd335f4c36187ef.mockapi.io/api/v1/orders`
- If you see JSON, API is working
- If you see error, check your project ID


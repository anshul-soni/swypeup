#!/bin/bash

# SwypeUp Deployment Test Script
# Replace BACKEND_URL with your actual Railway backend URL

BACKEND_URL="https://your-backend-url.railway.app"

echo "🚀 Testing SwypeUp Backend Deployment"
echo "======================================"

# Test 1: Health Check
echo "1. Testing health check..."
curl -s "$BACKEND_URL/" || echo "❌ Health check failed"

# Test 2: User Registration
echo -e "\n2. Testing user registration..."
REGISTER_RESPONSE=$(curl -s -X POST "$BACKEND_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "password123"
  }')

if echo "$REGISTER_RESPONSE" | grep -q "access_token"; then
    echo "✅ Registration successful"
    # Extract token for login test
    TOKEN=$(echo "$REGISTER_RESPONSE" | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)
else
    echo "❌ Registration failed: $REGISTER_RESPONSE"
fi

# Test 3: User Login
echo -e "\n3. Testing user login..."
LOGIN_RESPONSE=$(curl -s -X POST "$BACKEND_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }')

if echo "$LOGIN_RESPONSE" | grep -q "access_token"; then
    echo "✅ Login successful"
    # Extract token for authenticated tests
    TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)
else
    echo "❌ Login failed: $LOGIN_RESPONSE"
fi

# Test 4: Activity Feed (requires authentication)
if [ ! -z "$TOKEN" ]; then
    echo -e "\n4. Testing activity feed..."
    FEED_RESPONSE=$(curl -s -X GET "$BACKEND_URL/activities/feed" \
      -H "Authorization: Bearer $TOKEN")
    
    if echo "$FEED_RESPONSE" | grep -q "activities"; then
        echo "✅ Activity feed accessible"
    else
        echo "❌ Activity feed failed: $FEED_RESPONSE"
    fi
else
    echo -e "\n4. Skipping activity feed test (no token)"
fi

# Test 5: Chat Token Generation (requires authentication)
if [ ! -z "$TOKEN" ]; then
    echo -e "\n5. Testing chat token generation..."
    CHAT_RESPONSE=$(curl -s -X POST "$BACKEND_URL/chat/token" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d '{"userName": "Test User"}')
    
    if echo "$CHAT_RESPONSE" | grep -q "token"; then
        echo "✅ Chat token generation successful"
    else
        echo "❌ Chat token generation failed: $CHAT_RESPONSE"
    fi
else
    echo -e "\n5. Skipping chat token test (no token)"
fi

echo -e "\n🎉 Deployment test completed!"
echo "======================================"
echo "Next steps:"
echo "1. Test the frontend at your Railway frontend URL"
echo "2. Test the mobile app with the deployed backend"
echo "3. Verify chat functionality with Stream Chat"

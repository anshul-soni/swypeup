# SwypeUp Backend API Documentation

## Base URL
```
http://localhost:3000
```

## Authentication

All protected endpoints require a JWT token in the Authorization header:
```
Authorization: Bearer <your-jwt-token>
```

## Endpoints

### Authentication

#### POST /auth/register
Register a new user.

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "60f7b3b3b3b3b3b3b3b3b3b3",
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

#### POST /auth/login
Login with existing credentials.

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "60f7b3b3b3b3b3b3b3b3b3b3",
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

### User Profile

#### GET /users/me
Get the current user's profile.

**Headers:**
```
Authorization: Bearer <jwt-token>
```

**Response:**
```json
{
  "id": "60f7b3b3b3b3b3b3b3b3b3b3",
  "name": "John Doe",
  "email": "john@example.com",
  "bio": "I love outdoor activities!",
  "profilePictureUrl": "https://example.com/avatar.jpg",
  "createdAt": "2023-01-01T00:00:00.000Z",
  "updatedAt": "2023-01-01T00:00:00.000Z"
}
```

#### PUT /users/me
Update the current user's profile.

**Headers:**
```
Authorization: Bearer <jwt-token>
```

**Request Body:**
```json
{
  "name": "John Smith",
  "bio": "Updated bio",
  "profilePictureUrl": "https://example.com/new-avatar.jpg"
}
```

### Activities

#### POST /activities
Create a new activity.

**Headers:**
```
Authorization: Bearer <jwt-token>
```

**Request Body:**
```json
{
  "title": "Hiking Trip",
  "description": "Let's go hiking in the mountains!",
  "location": [-122.4194, 37.7749],
  "address": "123 Main St, San Francisco, CA",
  "startTime": "2023-12-25T10:00:00.000Z",
  "endTime": "2023-12-25T16:00:00.000Z",
  "maxParticipants": 10
}
```

**Response:**
```json
{
  "statusCode": 201,
  "data": {
    "id": "60f7b3b3b3b3b3b3b3b3b3b3",
    "title": "Hiking Trip",
    "description": "Let's go hiking in the mountains!",
    "location": {
      "type": "Point",
      "coordinates": [-122.4194, 37.7749]
    },
    "address": "123 Main St, San Francisco, CA",
    "startTime": "2023-12-25T10:00:00.000Z",
    "endTime": "2023-12-25T16:00:00.000Z",
    "maxParticipants": 10,
    "hostId": "60f7b3b3b3b3b3b3b3b3b3b3",
    "status": "active",
    "createdAt": "2023-01-01T00:00:00.000Z",
    "updatedAt": "2023-01-01T00:00:00.000Z"
  }
}
```

#### GET /activities/feed
Get nearby activities sorted by distance and time.

**Headers:**
```
Authorization: Bearer <jwt-token>
```

**Query Parameters:**
- `lat`: Latitude (required)
- `lon`: Longitude (required)

**Example:**
```
GET /activities/feed?lat=37.7749&lon=-122.4194
```

**Response:**
```json
{
  "statusCode": 200,
  "data": [
    {
      "id": "60f7b3b3b3b3b3b3b3b3b3b3",
      "title": "Hiking Trip",
      "description": "Let's go hiking in the mountains!",
      "location": {
        "type": "Point",
        "coordinates": [-122.4194, 37.7749]
      },
      "address": "123 Main St, San Francisco, CA",
      "startTime": "2023-12-25T10:00:00.000Z",
      "endTime": "2023-12-25T16:00:00.000Z",
      "maxParticipants": 10,
      "hostId": {
        "id": "60f7b3b3b3b3b3b3b3b3b3b3",
        "name": "John Doe",
        "profilePictureUrl": "https://example.com/avatar.jpg"
      },
      "status": "active"
    }
  ]
}
```

#### POST /activities/:id/join
Join an activity.

**Headers:**
```
Authorization: Bearer <jwt-token>
```

**Response:**
```json
{
  "statusCode": 200,
  "message": "Successfully joined activity"
}
```

#### GET /activities/me
Get activities for the current user.

**Headers:**
```
Authorization: Bearer <jwt-token>
```

**Response:**
```json
{
  "statusCode": 200,
  "data": {
    "hosting": [
      {
        "id": "60f7b3b3b3b3b3b3b3b3b3b3",
        "title": "Hiking Trip",
        "description": "Let's go hiking in the mountains!",
        "location": {
          "type": "Point",
          "coordinates": [-122.4194, 37.7749]
        },
        "address": "123 Main St, San Francisco, CA",
        "startTime": "2023-12-25T10:00:00.000Z",
        "endTime": "2023-12-25T16:00:00.000Z",
        "maxParticipants": 10,
        "hostId": {
          "id": "60f7b3b3b3b3b3b3b3b3b3b3",
          "name": "John Doe",
          "profilePictureUrl": "https://example.com/avatar.jpg"
        },
        "status": "active"
      }
    ],
    "participating": []
  }
}
```

### Chat

#### POST /chat/token
Generate a Stream Chat token for the current user.

**Headers:**
```
Authorization: Bearer <jwt-token>
```

**Response:**
```json
{
  "statusCode": 200,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "60f7b3b3b3b3b3b3b3b3b3b3",
      "name": "John Doe"
    }
  }
}
```

#### POST /chat/channels/:activityId/join
Join the chat channel for a specific activity.

**Headers:**
```
Authorization: Bearer <jwt-token>
```

**Response:**
```json
{
  "statusCode": 200,
  "message": "Successfully joined chat channel",
  "data": {
    "channelId": "activity-60f7b3b3b3b3b3b3b3b3b3b3"
  }
}
```

#### POST /chat/channels/:activityId/leave
Leave the chat channel for a specific activity.

**Headers:**
```
Authorization: Bearer <jwt-token>
```

**Response:**
```json
{
  "statusCode": 200,
  "message": "Successfully left chat channel"
}
```

#### GET /chat/channels/:activityId
Get information about a chat channel.

**Headers:**
```
Authorization: Bearer <jwt-token>
```

**Response:**
```json
{
  "statusCode": 200,
  "data": {
    "channelId": "activity-60f7b3b3b3b3b3b3b3b3b3b3",
    "members": [...],
    "messages": [...],
    "channel": {...}
  }
}
```

## Error Responses

All endpoints return appropriate HTTP status codes and error messages:

```json
{
  "statusCode": 400,
  "message": "Error description",
  "error": "Bad Request"
}
```

## Environment Variables

Create a `.env` file in the root directory:

```env
MONGO_URI=mongodb://localhost:27017/swypeup
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRES_IN=7d
STREAM_API_KEY=your-stream-api-key
STREAM_API_SECRET=your-stream-api-secret
```

## Running the Application

1. Install dependencies:
```bash
npm install
```

2. Start the development server:
```bash
npm run start:dev
```

3. Run tests:
```bash
npm test
```

4. Run e2e tests:
```bash
npm run test:e2e
```

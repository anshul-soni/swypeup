# Railway Deployment Guide for SwypeUp

## 🚀 Step-by-Step Deployment

### Prerequisites
- GitHub account
- Railway account (free at railway.app)
- Stream Chat account (free at getstream.io)

### Step 1: Prepare Your Repository

1. **Commit your code to GitHub:**
   ```bash
   git add .
   git commit -m "Initial commit for Railway deployment"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/swypeup.git
   git push -u origin main
   ```

### Step 2: Deploy Backend to Railway

1. **Go to [Railway.app](https://railway.app)**
2. **Sign in with GitHub**
3. **Click "New Project" → "Deploy from GitHub repo"**
4. **Select your repository**
5. **Choose the `swypeup-backend` directory**
6. **Add Environment Variables:**
   - `MONGO_URI` - Railway will provide MongoDB automatically
   - `JWT_SECRET` - Generate a strong random string
   - `JWT_EXPIRES_IN` - Set to `7d`
   - `STREAM_API_KEY` - From your Stream Chat dashboard
   - `STREAM_API_SECRET` - From your Stream Chat dashboard
   - `NODE_ENV` - Set to `production`

### Step 3: Deploy Frontend to Railway

1. **Create another Railway project**
2. **Select the same repository**
3. **Choose the `swypeup_app` directory**
4. **Add Environment Variables:**
   - `BACKEND_URL` - Your backend Railway URL (e.g., `https://swypeup-backend-production.up.railway.app`)

### Step 4: Update Frontend Configuration

After deployment, update these files with your Railway URLs:

1. **Update `swypeup_app/lib/services/api_service.dart`:**
   ```dart
   static const String baseUrl = 'https://your-backend-railway-url.com';
   ```

2. **Update `swypeup_app/lib/providers/chat_provider.dart`:**
   ```dart
   _client = StreamChatClient(
     'your-stream-api-key', // Your actual Stream API key
     logLevel: Level.INFO,
   );
   ```

### Step 5: Test Your Deployment

1. **Test Backend API:**
   ```bash
   curl https://your-backend-url.railway.app/
   ```

2. **Test Frontend:**
   - Visit your frontend Railway URL
   - Test registration and login
   - Test activity creation and discovery

## 🔧 Environment Variables Guide

### Backend Variables (Railway Dashboard)
- `MONGO_URI` - Automatically provided by Railway
- `JWT_SECRET` - Generate with: `openssl rand -base64 32`
- `JWT_EXPIRES_IN` - `7d`
- `STREAM_API_KEY` - From Stream Chat dashboard
- `STREAM_API_SECRET` - From Stream Chat dashboard
- `NODE_ENV` - `production`

### Frontend Variables (Railway Dashboard)
- `BACKEND_URL` - Your backend Railway URL

## 🛡️ Security Notes

- ✅ Never commit `.env` files to Git
- ✅ Use strong, unique JWT secrets
- ✅ Keep Stream Chat API keys secure
- ✅ Use HTTPS URLs in production
- ✅ Regularly rotate secrets

## 📱 Testing Your Deployed App

### Backend Testing
```bash
# Test registration
curl -X POST https://your-backend-url.railway.app/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","password":"password123"}'

# Test login
curl -X POST https://your-backend-url.railway.app/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

### Frontend Testing
1. Open your frontend Railway URL
2. Register a new account
3. Create an activity
4. Test the swipe interface
5. Test chat functionality

## 🚨 Troubleshooting

### Common Issues
1. **Build Failures**: Check Railway logs for dependency issues
2. **Database Connection**: Verify MongoDB URI in Railway dashboard
3. **CORS Errors**: Backend should allow your frontend domain
4. **Environment Variables**: Double-check all variables are set correctly

### Getting Help
- Check Railway deployment logs
- Verify environment variables
- Test API endpoints individually
- Check Stream Chat dashboard for API key issues

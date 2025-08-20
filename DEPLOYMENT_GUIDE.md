# SwypeUp Deployment Guide

This guide covers deploying the SwypeUp app to various platforms.

## 🚀 Quick Start Deployment

### Option 1: Railway (Recommended for Beginners)

**Backend Deployment:**
1. Go to [Railway.app](https://railway.app)
2. Connect your GitHub repository
3. Create new project from GitHub repo
4. Select the `swypeup-backend` directory
5. Add environment variables:
   - `MONGO_URI` (Railway will provide MongoDB)
   - `JWT_SECRET` (your secret key)
   - `JWT_EXPIRES_IN=7d`
   - `STREAM_API_KEY` (from Stream Chat)
   - `STREAM_API_SECRET` (from Stream Chat)
6. Deploy automatically

**Frontend Deployment:**
1. Create another Railway project for frontend
2. Select the `swypeup_app` directory
3. Set build command: `flutter build web`
4. Set output directory: `build/web`
5. Deploy

### Option 2: Heroku

**Backend Deployment:**
```bash
cd swypeup-backend

# Install Heroku CLI
# Create Heroku app
heroku create swypeup-backend

# Add MongoDB addon
heroku addons:create mongolab:sandbox

# Set environment variables
heroku config:set JWT_SECRET=your-super-secret-jwt-key
heroku config:set JWT_EXPIRES_IN=7d
heroku config:set STREAM_API_KEY=your-stream-api-key
heroku config:set STREAM_API_SECRET=your-stream-api-secret

# Deploy
git add .
git commit -m "Deploy to Heroku"
git push heroku main
```

## 🌐 Platform-Specific Deployment

### Backend Deployment Options

#### 1. **Railway** (Recommended)
- **Pros**: Easy setup, automatic deployments, free tier
- **Cons**: Limited free tier
- **Best for**: Prototypes and small projects

#### 2. **Heroku**
- **Pros**: Well-established, good documentation
- **Cons**: No free tier anymore
- **Best for**: Production apps with budget

#### 3. **DigitalOcean App Platform**
- **Pros**: Good performance, reasonable pricing
- **Cons**: More complex setup
- **Best for**: Production apps

#### 4. **AWS (Advanced)**
- **Pros**: Highly scalable, many services
- **Cons**: Complex setup, can be expensive
- **Best for**: Large-scale production apps

#### 5. **Vercel**
- **Pros**: Great for Node.js, automatic deployments
- **Cons**: Limited to serverless functions
- **Best for**: API-focused apps

### Frontend Deployment Options

#### 1. **Firebase Hosting** (Web)
```bash
cd swypeup_app

# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase
firebase init hosting

# Build for web
flutter build web

# Deploy
firebase deploy
```

#### 2. **Vercel** (Web)
```bash
cd swypeup_app

# Install Vercel CLI
npm install -g vercel

# Build for web
flutter build web

# Deploy
vercel build/web
```

#### 3. **Netlify** (Web)
```bash
cd swypeup_app

# Build for web
flutter build web

# Drag and drop build/web folder to Netlify
```

#### 4. **App Stores** (Mobile)
- **Google Play Store**: Upload APK/AAB
- **Apple App Store**: Upload through Xcode

## 🔧 Environment Configuration

### Backend Environment Variables

Create a `.env` file in `swypeup-backend`:
```env
# Database
MONGO_URI=mongodb://localhost:27017/swypeup

# Authentication
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRES_IN=7d

# Stream Chat
STREAM_API_KEY=your-stream-api-key
STREAM_API_SECRET=your-stream-api-secret

# Server
PORT=3000
NODE_ENV=production
```

### Frontend Configuration

Update `lib/services/api_service.dart`:
```dart
class ApiService {
  // Change this to your deployed backend URL
  static const String baseUrl = 'https://your-backend-url.com';
  // ...
}
```

Update `lib/providers/chat_provider.dart`:
```dart
_client = StreamChatClient(
  'your-stream-api-key', // Replace with your actual API key
  logLevel: Level.INFO,
);
```

## 📱 Mobile App Deployment

### Android Deployment

#### 1. **Build APK**
```bash
cd swypeup_app

# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (recommended for Play Store)
flutter build appbundle --release
```

#### 2. **Google Play Console**
1. Create developer account ($25 one-time fee)
2. Create new app
3. Upload APK/AAB file
4. Fill in app details
5. Submit for review

#### 3. **Internal Testing**
1. Create internal testing track
2. Add testers by email
3. Share testing link

### iOS Deployment

#### 1. **Build iOS App**
```bash
cd swypeup_app

# Build for iOS
flutter build ios --release
```

#### 2. **App Store Connect**
1. Create Apple Developer account ($99/year)
2. Create new app in App Store Connect
3. Upload build through Xcode
4. Submit for review

#### 3. **TestFlight**
1. Create TestFlight build
2. Add internal testers
3. Share TestFlight link

## 🔒 Security Considerations

### Production Security Checklist

- [ ] **Environment Variables**: Never commit secrets to Git
- [ ] **HTTPS**: Use SSL certificates
- [ ] **CORS**: Configure allowed origins
- [ ] **Rate Limiting**: Implement API rate limiting
- [ ] **Input Validation**: Sanitize all inputs
- [ ] **Database Security**: Use strong passwords
- [ ] **Monitoring**: Set up error tracking

### SSL/HTTPS Setup

#### Railway/Heroku
- Automatic SSL certificates
- No additional setup needed

#### Custom Domain
```bash
# Install SSL certificate
certbot --nginx -d yourdomain.com

# Or use Let's Encrypt
sudo certbot certonly --standalone -d yourdomain.com
```

## 📊 Monitoring and Analytics

### Backend Monitoring

#### 1. **Error Tracking**
```bash
# Install Sentry
npm install @sentry/node

# Add to main.ts
import * as Sentry from "@sentry/node";
Sentry.init({ dsn: "your-sentry-dsn" });
```

#### 2. **Performance Monitoring**
```bash
# Install New Relic
npm install newrelic

# Or use built-in monitoring
npm install express-status-monitor
```

### Frontend Monitoring

#### 1. **Crash Reporting**
```yaml
# pubspec.yaml
dependencies:
  sentry_flutter: ^7.0.0
```

#### 2. **Analytics**
```yaml
# pubspec.yaml
dependencies:
  firebase_analytics: ^10.0.0
```

## 🔄 CI/CD Pipeline

### GitHub Actions

Create `.github/workflows/deploy.yml`:
```yaml
name: Deploy to Production

on:
  push:
    branches: [ main ]

jobs:
  deploy-backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
        with:
          node-version: '18'
      - run: |
          cd swypeup-backend
          npm install
          npm run build
          npm run test
      - name: Deploy to Railway
        run: |
          # Add Railway deployment steps

  deploy-frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.0'
      - run: |
          cd swypeup_app
          flutter pub get
          flutter build web
      - name: Deploy to Firebase
        run: |
          # Add Firebase deployment steps
```

## 🚨 Troubleshooting

### Common Deployment Issues

#### 1. **Build Failures**
```bash
# Check Flutter version
flutter --version

# Clean and rebuild
flutter clean
flutter pub get
flutter build web
```

#### 2. **Database Connection Issues**
```bash
# Check MongoDB connection
mongo your-database-url --eval "db.stats()"

# Test connection string
mongodb://username:password@host:port/database
```

#### 3. **CORS Issues**
```typescript
// In main.ts
app.enableCors({
  origin: ['https://your-frontend-domain.com'],
  credentials: true,
});
```

#### 4. **Environment Variables**
```bash
# Check environment variables
heroku config
railway variables
```

## 📈 Scaling Considerations

### Backend Scaling

#### 1. **Database Scaling**
- Use MongoDB Atlas for managed database
- Implement database sharding
- Add read replicas

#### 2. **Application Scaling**
- Use load balancers
- Implement horizontal scaling
- Add caching (Redis)

#### 3. **CDN Setup**
- Use CloudFlare for static assets
- Implement image optimization
- Add caching headers

### Frontend Scaling

#### 1. **Performance Optimization**
- Implement lazy loading
- Use code splitting
- Optimize images

#### 2. **Caching Strategy**
- Implement service workers
- Use browser caching
- Add offline support

## 🎯 Next Steps

After deployment:

1. **Set up monitoring** and error tracking
2. **Configure analytics** to track user behavior
3. **Implement A/B testing** for features
4. **Set up automated backups**
5. **Plan for scaling** as user base grows
6. **Create disaster recovery** plan
7. **Set up user feedback** system

## 📞 Support

- **Documentation**: Check platform-specific docs
- **Community**: Stack Overflow, Reddit
- **Official Support**: Platform support channels
- **GitHub Issues**: For code-specific problems


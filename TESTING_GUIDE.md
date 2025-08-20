# SwypeUp Testing Guide

This guide covers how to test the SwypeUp app at different stages of development.

## 🏠 Local Development Testing

### Prerequisites
- Node.js and npm installed
- Flutter SDK installed
- MongoDB running locally
- Android Studio / VS Code with Flutter extension

### 1. Backend Testing

#### Start MongoDB
```bash
# Install MongoDB locally or use Docker
docker run -d -p 27017:27017 --name mongodb mongo:latest
```

#### Start Backend Server
```bash
cd swypeup-backend
npm install
npm run start:dev
```

#### Test Backend API
```bash
# Test registration
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","password":"password123"}'

# Test login
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

### 2. Frontend Testing

#### Run Flutter App
```bash
cd swypeup_app
flutter pub get
flutter run
```

#### Test on Different Platforms
```bash
# Android
flutter run -d android

# iOS (requires Mac)
flutter run -d ios

# Web
flutter run -d chrome

# Windows
flutter run -d windows
```

## 🧪 Automated Testing

### Backend Tests
```bash
cd swypeup-backend

# Unit tests
npm run test

# E2E tests
npm run test:e2e

# Test coverage
npm run test:cov
```

### Frontend Tests
```bash
cd swypeup_app

# Unit tests
flutter test

# Widget tests
flutter test test/widget_test.dart

# Integration tests
flutter test integration_test/
```

## 🌐 Cloud Testing

### 1. Backend Deployment Testing

#### Heroku Deployment
```bash
cd swypeup-backend

# Create Heroku app
heroku create swypeup-backend

# Add MongoDB addon
heroku addons:create mongolab:sandbox

# Set environment variables
heroku config:set JWT_SECRET=your-super-secret-jwt-key
heroku config:set JWT_EXPIRES_IN=7d

# Deploy
git add .
git commit -m "Deploy to Heroku"
git push heroku main

# Test deployed API
curl https://your-app-name.herokuapp.com/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","password":"password123"}'
```

#### Railway Deployment
1. Connect GitHub repo to Railway
2. Set environment variables in Railway dashboard
3. Deploy automatically on push

### 2. Frontend Deployment Testing

#### Firebase Hosting (Web)
```bash
cd swypeup_app

# Build for web
flutter build web

# Deploy to Firebase
firebase deploy

# Test at: https://your-project.web.app
```

#### App Store Testing

**Android (Google Play Console):**
1. Build APK: `flutter build apk --release`
2. Upload to Google Play Console
3. Create internal testing track
4. Test on physical devices

**iOS (TestFlight):**
1. Build iOS: `flutter build ios --release`
2. Upload to App Store Connect
3. Create TestFlight build
4. Test on iOS devices

## 🔧 Testing Checklist

### Backend API Testing
- [ ] User registration
- [ ] User login
- [ ] JWT token validation
- [ ] Activity creation
- [ ] Activity feed retrieval
- [ ] Activity joining
- [ ] Chat token generation
- [ ] Chat channel management

### Frontend Testing
- [ ] Authentication flow
- [ ] Activity discovery
- [ ] Swipe interactions
- [ ] Activity joining
- [ ] Chat functionality
- [ ] Error handling
- [ ] Loading states
- [ ] Navigation

### Integration Testing
- [ ] End-to-end user flows
- [ ] Real-time chat
- [ ] Activity synchronization
- [ ] Cross-platform compatibility

## 🐛 Debugging

### Backend Debugging
```bash
# Enable debug logging
DEBUG=* npm run start:dev

# Check MongoDB connection
mongo swypeup --eval "db.stats()"

# Monitor API requests
npm install -g http-server
http-server -p 8080 --cors
```

### Frontend Debugging
```bash
# Enable debug mode
flutter run --debug

# Check device logs
flutter logs

# Hot reload for development
flutter run --hot
```

## 📱 Device Testing

### Android Testing
- **Emulator**: Android Studio AVD
- **Physical Device**: Enable USB debugging
- **Test Devices**: Different screen sizes and Android versions

### iOS Testing
- **Simulator**: Xcode iOS Simulator
- **Physical Device**: TestFlight or development provisioning
- **Test Devices**: iPhone and iPad variants

### Web Testing
- **Browsers**: Chrome, Firefox, Safari, Edge
- **Responsive**: Test different screen sizes
- **Mobile Web**: Test on mobile browsers

## 🔒 Security Testing

### Authentication
- [ ] JWT token validation
- [ ] Password hashing
- [ ] Session management
- [ ] API endpoint protection

### Data Validation
- [ ] Input sanitization
- [ ] SQL injection prevention
- [ ] XSS protection
- [ ] CORS configuration

## 📊 Performance Testing

### Backend Performance
```bash
# Load testing with Artillery
npm install -g artillery
artillery quick --count 100 --num 10 http://localhost:3000/auth/login
```

### Frontend Performance
- [ ] App startup time
- [ ] Memory usage
- [ ] Battery consumption
- [ ] Network efficiency

## 🚀 Production Testing

### Pre-deployment Checklist
- [ ] Environment variables configured
- [ ] Database migrations applied
- [ ] SSL certificates installed
- [ ] Monitoring tools configured
- [ ] Backup strategy implemented

### Post-deployment Testing
- [ ] Smoke tests on production
- [ ] User acceptance testing
- [ ] Performance monitoring
- [ ] Error tracking setup

## 📞 Support and Troubleshooting

### Common Issues
1. **MongoDB Connection**: Check connection string and network
2. **JWT Issues**: Verify secret key and expiration
3. **CORS Errors**: Configure allowed origins
4. **Flutter Build Issues**: Check dependencies and platform support

### Getting Help
- Check logs for error messages
- Use debugging tools
- Consult documentation
- Open issues on GitHub


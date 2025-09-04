# Use the official Flutter image
FROM ghcr.io/cirruslabs/flutter:stable AS build

# Set working directory
WORKDIR /app

# Copy web-compatible pubspec
COPY pubspec_web.yaml ./pubspec.yaml

# Get dependencies
RUN flutter pub get

# Copy source code
COPY . .

# Replace screens with web-compatible versions
RUN cp lib/screens/auth_screen_web.dart lib/screens/auth_screen.dart
RUN cp lib/screens/home_screen_web.dart lib/screens/home_screen.dart
RUN cp lib/main_web.dart lib/main.dart

# Configure project for web and build
RUN flutter create . --platforms web
# Allow injecting backend URL at build time
ARG BACKEND_URL

# Build web with BACKEND_URL provided via dart-define (fallback handled in code)
RUN flutter build web --release --dart-define=BACKEND_URL=$BACKEND_URL

# Use nginx to serve the built app
FROM nginx:alpine

# Copy built app to nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]

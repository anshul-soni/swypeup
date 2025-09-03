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

# Replace main.dart with web-compatible version
RUN cp lib/main_web.dart lib/main.dart

# Build Flutter web app
RUN flutter build web --release

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

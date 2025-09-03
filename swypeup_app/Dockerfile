# Use the official Flutter image with web support
FROM ghcr.io/cirruslabs/flutter:stable-web AS build

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml ./

# Get dependencies
RUN flutter pub get

# Copy source code
COPY . .

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

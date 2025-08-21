# Use the official Flutter image
FROM dart:stable AS build

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN dart pub get

# Copy source code
COPY . .

# Build Flutter web app
RUN dart pub get
RUN dart run build_runner build --delete-conflicting-outputs
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

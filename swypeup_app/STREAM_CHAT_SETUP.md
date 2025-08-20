# Stream Chat Setup Guide

This guide will help you set up Stream Chat for the SwypeUp app.

## 1. Create a Stream Account

1. Go to [https://getstream.io/](https://getstream.io/)
2. Sign up for a free account
3. Create a new app in the Stream dashboard

## 2. Get Your API Keys

1. In your Stream dashboard, go to your app
2. Navigate to "API Keys" in the sidebar
3. Copy your **API Key** and **API Secret**

## 3. Update Environment Variables

### Backend (.env file)
Add these to your `swypeup-backend/.env` file:
```env
STREAM_API_KEY=your-stream-api-key-here
STREAM_API_SECRET=your-stream-api-secret-here
```

### Frontend
Update the API key in `lib/providers/chat_provider.dart`:
```dart
_client = StreamChatClient(
  'your-stream-api-key-here', // Replace with your actual API key
  logLevel: Level.INFO,
);
```

## 4. Install Dependencies

### Backend
```bash
cd swypeup-backend
npm install stream-chat
```

### Frontend
The Stream Chat Flutter dependency is already included in `pubspec.yaml`:
```yaml
stream_chat_flutter: ^6.5.0
```

Run:
```bash
cd swypeup_app
flutter pub get
```

## 5. Test the Integration

1. Start your backend server:
```bash
cd swypeup-backend
npm run start:dev
```

2. Start your Flutter app:
```bash
cd swypeup_app
flutter run
```

3. Create an activity and test the chat functionality

## 6. Features Included

- **Real-time messaging**: Instant message delivery
- **Group chats**: Activity-based chat rooms
- **User management**: Automatic user creation and management
- **Message history**: Persistent chat history
- **Typing indicators**: Real-time typing status
- **Read receipts**: Message read status
- **File attachments**: Support for images and files
- **Push notifications**: Real-time notifications (requires additional setup)

## 7. Customization

### Chat UI Customization
You can customize the Stream Chat UI by modifying the theme in `lib/screens/chat_screen.dart`:

```dart
StreamChat(
  client: chatState.client!,
  streamChatTheme: StreamChatTheme(
    // Customize colors, fonts, etc.
  ),
  child: StreamChannel(
    // Your chat UI
  ),
)
```

### Message Types
Stream Chat supports various message types:
- Text messages
- Image attachments
- File attachments
- Custom message types

### Channel Types
Currently using 'messaging' channel type, but you can also use:
- 'livestream' for live streaming
- 'commerce' for e-commerce
- 'team' for team collaboration

## 8. Production Considerations

1. **Security**: Use environment variables for API keys
2. **Rate Limiting**: Be aware of Stream's rate limits
3. **Monitoring**: Set up monitoring for chat performance
4. **Backup**: Consider backing up chat data
5. **Compliance**: Ensure compliance with data protection regulations

## 9. Troubleshooting

### Common Issues

1. **Connection Failed**
   - Check your API key and secret
   - Verify network connectivity
   - Check Stream service status

2. **Messages Not Sending**
   - Verify user authentication
   - Check channel permissions
   - Ensure user is a member of the channel

3. **UI Not Loading**
   - Check Flutter dependencies
   - Verify Stream Chat Flutter version
   - Check for console errors

### Support

- [Stream Chat Documentation](https://getstream.io/chat/docs/)
- [Stream Chat Flutter Documentation](https://getstream.io/chat/flutter/tutorial/)
- [Stream Community](https://getstream.io/community/)

## 10. Next Steps

After setting up Stream Chat, consider implementing:

1. **Push Notifications**: For chat messages
2. **Message Reactions**: Like, heart, etc.
3. **Message Threading**: Reply to specific messages
4. **Voice Messages**: Audio message support
5. **Video Calls**: Integrate with Stream Video
6. **Message Search**: Search through chat history
7. **Message Moderation**: Content filtering


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/auth_screen_web.dart';
import 'screens/home_screen_web.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SwypeUpApp(),
    ),
  );
}

class SwypeUpApp extends ConsumerStatefulWidget {
  const SwypeUpApp({super.key});

  @override
  ConsumerState<SwypeUpApp> createState() => _SwypeUpAppState();
}

class _SwypeUpAppState extends ConsumerState<SwypeUpApp> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    return MaterialApp(
      title: 'SwypeUp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      home: authState.isAuthenticated ? const HomeScreen() : const AuthScreen(),
    );
  }
}

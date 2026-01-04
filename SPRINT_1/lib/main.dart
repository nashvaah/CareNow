import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/features/auth/services/auth_provider.dart';
import 'src/core/theme/app_theme.dart';
import 'src/features/onboarding/screens/language_selection_screen.dart';
import 'src/features/auth/screens/login_screen.dart';
import 'src/features/dashboard/screens/dashboard_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:carenow/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const CareNowApp());
}

class CareNowApp extends StatelessWidget {
  const CareNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return MaterialApp(
      title: 'CareNow',
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light, 
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: authProvider.textScaleFactor),
          child: child!,
        );
      },
      locale: authProvider.currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), 
        Locale('ml'), 
      ],
      debugShowCheckedModeBanner: false,
      home: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (auth.isLoading) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          if (auth.isFirstLaunch) {
            return const LanguageSelectionScreen();
          }

          if (!auth.isAuthenticated) {
            return const LoginScreen();
          }

          return const DashboardScreenWrapper();
        },
      ),
    );
  }
}


import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:market/providers/image_provider.dart';
import 'package:market/services/shopping_list_service.dart';
import 'package:market/views/authentication_screen.dart';
import 'package:market/providers/notification_provider.dart';
import 'package:market/services/firebase_service.dart';
import 'package:market/services/notification_service.dart';
import 'package:market/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'controllers/common/themes.dart';
import 'controllers/theme_controller.dart';

const storage = FlutterSecureStorage();

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        name: "freshly",
        options: const FirebaseOptions(
          apiKey: "AIzaSyC4NuBfxIl3AWAwTLXqWhJAdvm14iIn12I", //
          authDomain: "market-229ca.firebaseapp.com",
          projectId: "market-229ca",
          storageBucket: "market-229ca.appspot.com",
          messagingSenderId: "847650161276",
          appId: "1:847650161276:web:07031ea27ebfa08a437ff9",
          measurementId: "G-QLC2SX2XB5",
        )
    );
  }

  NotificationService.initialize();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    NotificationService.handleMessage(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    NotificationService.handleMessage(message);
  });

  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      NotificationService.handleMessage(message);
    }
  });

  FirebaseMessaging.instance.onTokenRefresh
      .listen((fcmToken) async{
        await FirebaseService.instance.postToken(fcmToken);
      })
      .onError((err) {

      });

  Get.put(ThemeController(), permanent: true);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ImageFileProvider()),
        ChangeNotifierProvider(create: (_) => ShoppingListService()),
      ],
      child: const MyApp(),
    )

  );
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final List<String> imageUrls = [
    'assets/onboarding_1.png',
    'assets/onboarding_2.png',
    'assets/onboarding_3.png',
    'assets/landing-banner.png',
    'assets/logo.png',
    'assets/discover-dairy.jpg',
    'assets/discover-meat.jpg',
    'assets/discover-fruits.jpg',
    'assets/discover-vegetables.jpg',
  ];

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for (var url in imageUrls) {
      precacheImage(AssetImage(url), context);
    }

    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: isDarkMode ? Colors.black : Colors.white,
      systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
    ));

    return GetMaterialApp(
      navigatorKey: navigatorKey,
      translations: AppTranslations(),
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      supportedLocales: const [
        Locale('en', ''),
        Locale('bg', ''),
      ],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      title: "Freshly",
      home: const AuthenticationWrapper(),
    );
  }
}

class AppTranslations extends Translations {
  final Map<String, Map<String, String>> _translations = {};

  AppTranslations() {
    _loadTranslations();
  }

  @override
  Map<String, Map<String, String>> get keys => _translations;

  Future<void> _loadTranslations() async {
    _translations['en'] = await _loadArbFile('lib/l10n/app_en.arb');
    _translations['bg'] = await _loadArbFile('lib/l10n/app_bg.arb');
  }

  Future<Map<String, String>> _loadArbFile(String path) async {
    final String arbContent = await rootBundle.loadString(path);
    final Map<String, dynamic> arbMap = jsonDecode(arbContent);

    // Use `entries.where` to filter out keys starting with "@"
    final filteredEntries = arbMap.entries
        .where((entry) => !entry.key.startsWith('@'))
        .map((entry) => MapEntry(entry.key, entry.value.toString()));

    return Map.fromEntries(filteredEntries);
  }
}

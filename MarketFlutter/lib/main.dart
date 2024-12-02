import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:market/providers/image_provider.dart';
import 'package:market/services/authentication_wrapper.dart';
import 'package:market/providers/locale_provider.dart';
import 'package:market/providers/notification_provider.dart';
import 'package:market/services/notification_service.dart';
import 'package:market/services/offer_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
  await Firebase.initializeApp(
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

  NotificationService.initialize();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Message received while in foreground: ${message.notification?.title}');
    NotificationService.handleMessage(message);
    // Show a custom in-app notification
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('Notification clicked: ${message.notification?.title}');
    NotificationService.handleMessage(message);

  });

  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      print('Notification clicked (app was terminated): ${message.notification?.title}');
      NotificationService.handleMessage(message);

    }
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ImageFileProvider()),
      ],
      child: MyApp(),
    )

  );
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<String> imageUrls = [
    'assets/onboarding_1.png',
    'assets/onboarding_2.png',
    'assets/onboarding_3.png',
    'assets/logo.png',
    'assets/discover-dairy.jpg',
    'assets/discover-meat.jpg',
    'assets/discover-fruits.jpg',
    'assets/discover-vegetables.jpg',

  ];

  @override
  void initState(){
    super.initState();
    OfferService.instance.loadOffers();
  }

  Locale _locale = const Locale('en', ''); // Default language

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }


  @override
  Widget build(BuildContext context) {
    for (var url in imageUrls) {
      precacheImage(AssetImage(url), context);
    }

    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
            ),
            useMaterial3: true,
            // Define the default brightness and colors.
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xffFFFFFF),
                secondary: const Color(0xff40B886),
                primary: const Color(0xff2C92FF),
                background: const Color(0xffFFFFFF),
                tertiary: const Color(0xff2C2B2B)
            ),
          ),
          supportedLocales: const [
            Locale('en', ''),
            Locale('bg', ''),
          ],
          locale: localeProvider.locale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate,
          ],
          home: const AuthenticationWrapper(),
        );
      },
    );
  }
}

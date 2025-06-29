import 'package:evently_app/firebase_utilis.dart';
import 'package:evently_app/l10n/app_localizations.dart';
import 'package:evently_app/model/event.dart';
import 'package:evently_app/providers/event_list_provider.dart';
import 'package:evently_app/providers/language_provider.dart';
import 'package:evently_app/providers/theme_provider.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/auth/login_screen.dart';
import 'package:evently_app/ui/auth/register_screen.dart';
import 'package:evently_app/ui/home/tabs/home_tab/create_event.dart';
import 'package:evently_app/ui/home/tabs/home_tab/event_details/event_details.dart';
import 'package:evently_app/ui/home/tabs/home_tab/pick_location_screen.dart';
import 'package:evently_app/ui/home/tabs/map_tab/map_tab.dart';
import 'package:evently_app/ui/home_screen.dart';
import 'package:evently_app/ui/splash/splash_screen.dart';
import 'package:evently_app/utilis/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseFirestore.instance.disableNetwork();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => EventListProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartUpScreen(),
      routes: {
        HomeScreen.routName: (context) => HomeScreen(),
        CreateEvent.routeName: (context) => CreateEvent(),
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        MapTab.routeName: (context) => MapTab(),
        PickLocationScreen.routeName: (context) => PickLocationScreen(),
        EventDetailsScreen.routeName: (context) {
          final event = ModalRoute.of(context)!.settings.arguments as Event;
          return EventDetailsScreen(event: event);
        }
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(languageProvider.currentLocal),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.currentTheme,
    );
  }
}

class StartUpScreen extends StatefulWidget {
  const StartUpScreen({super.key});

  @override
  State<StartUpScreen> createState() => _StartUpScreenState();
}

class _StartUpScreenState extends State<StartUpScreen> {
  Widget? nextScreen;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      final screen = await _handleStartLogicWithSplash(context);
      setState(() {
        nextScreen = screen;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return nextScreen ?? SplashScreen();
  }

  Future<Widget> _handleStartLogicWithSplash(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return LoginScreen();
    }
    final myUser = await FirebaseUtilis.readFromFireStore(currentUser.uid);
    if (myUser == null) {
      await FirebaseAuth.instance.signOut();
      return LoginScreen();
    }
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.updateUser(myUser);
    final event = Provider.of<EventListProvider>(context, listen: false);
    event.changeSelectedIndex(0, myUser.id);
    return HomeScreen();
  }
}

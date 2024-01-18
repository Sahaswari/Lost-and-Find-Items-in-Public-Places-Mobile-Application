import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lostthingfindapplication/providers/user_provider.dart';
import 'package:lostthingfindapplication/responsive/mobile_screen_layout.dart';
import 'package:lostthingfindapplication/responsive/reponsive_layout_screen.dart';
import 'package:lostthingfindapplication/responsive/web_screen_layout.dart';
import 'package:lostthingfindapplication/screens/login_screen.dart';
//import 'package:lostthingfindapplication/responsive/mobile_screen_layout.dart';
//import 'package:lostthingfindapplication/responsive/web_screen_layout.dart';
//import 'package:lostthingfindapplication/responsive/reponsive_layout_screen.dart';
//import 'package:lostthingfindapplication/screens/login_screen.dart';
import 'package:lostthingfindapplication/utils/colors.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyA2vjhZSLl3H6z1pT5ecrv2jFWsPeHnwN0',
        appId: '1:727710266289:web:069b42a83596da83d70390',
        messagingSenderId: "727710266289",
        projectId: "lostthingfindapplicationorg",
        storageBucket: "lostthingfindapplicationorg.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Find Your Lost Things',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
            return const LoginScreen();
          },
        ),

        //home:const ResponsiveLayout(webScreenLayout: webScreenLayout(), mobileScreenLayout: mobileScreenLayout(),
      ),
    );
  }
}

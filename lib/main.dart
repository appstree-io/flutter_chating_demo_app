import 'package:chat_app/screens/complete_profile_page.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uuid/uuid.dart';
import 'firebase_options.dart';

var uuid = Uuid();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: AuthStateChanges(),
      builder: EasyLoading.init(),
    );
  }
}

class AuthStateChanges extends StatefulWidget {
  const AuthStateChanges({super.key});

  @override
  State<AuthStateChanges> createState() => _AuthStateChangesState();
}

class _AuthStateChangesState extends State<AuthStateChanges> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
//loading screen
            return Container();
          }
          if (userSnapshot.connectionState == ConnectionState.done) {
//state is loaded check if snapshot has data
            if (userSnapshot.hasData) {
              return LoginPage();
            } else {
              return HomePage();
            }
          } else if (userSnapshot.connectionState == ConnectionState.none) {
            return AuthStateChanges();
          } else {
            return HomePage();
          }
        });
  }
}

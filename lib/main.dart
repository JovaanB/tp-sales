import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tp_sales/firebase_options.dart';

import 'dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen()
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

   Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return const LoginScreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      )
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  loginUsingEmailPassword({ required String email, required String password, required BuildContext context }) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if(e.code == "user-not-found") {
        print("Aucun utilisateur avec cet email.");
      }
    }

    return user;
  }

  @override
  Widget build(BuildContext context) {

    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0), 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Sales", style: TextStyle(color: Colors.black38, fontSize: 28.0, fontWeight: FontWeight.bold )),
          const Text("Se connecter", style: TextStyle(color: Colors.black, fontSize: 44.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 44.0),
          TextField(controller: _emailController,  keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(
            hintText: "Email",
            prefixIcon: Icon(Icons.mail, color: Colors.black)
          )),
          const SizedBox(height: 26.0),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Mot de passe",
              prefixIcon: Icon(Icons.lock, color: Colors.black)
            ),
          ),
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                onPressed: () async {
                  User? user = await loginUsingEmailPassword(email: _emailController.text, password: _passwordController.text, context: context);
                  if(user != null) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const DashboardScreen()));
                  }
                }, 
                fillColor: const Color(0xFF0069FE),
                elevation: 0.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: const Text("Connexion", style: TextStyle(color: Colors.white, fontSize: 18.0),)
              )
            )
        ]
      )
      );
  }
}
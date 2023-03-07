import 'package:flutter/material.dart';

import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Image(
                image: AssetImage('assets/Logo.png'),
                width: 150.0,
              ),
              const Text("Bienvenido/a \na Mujuke",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              const Text(
                  "Para usar nuestra aplicacion\nprimero debe de iniciar sesion\ncon Google",
                  style: TextStyle(fontSize: 20)),
              GestureDetector(
                onTap: () {
                  AuthService().signInWithGoogle();
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Image(
                          image: AssetImage('assets/google.png'),
                          width: 40,
                        ),
                        const SizedBox(width: 20),
                        const Text(
                          'Iniciar Sesion con Google',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

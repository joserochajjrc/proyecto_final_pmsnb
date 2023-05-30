import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyectofinal_pmsnb/services/email_authentication.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  EmailAuth emailAuth = EmailAuth();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    var proveedor = 'assets/logoapp.png';
    for (UserInfo userInfo in user.providerData) {
      if (userInfo.providerId == 'google.com') {
        proveedor = 'assets/google.png';
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Perfil',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 32,
            ),
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(user.photoURL!),
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              'Nombre: ${user.displayName}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(proveedor, height: 15),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Correo: ${user.email}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}

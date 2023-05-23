import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../services/email_authentication.dart';

class passwordScreen extends StatefulWidget {
  const passwordScreen({super.key});

  @override
  State<passwordScreen> createState() => _passwordScreenState();
}

class _passwordScreenState extends State<passwordScreen> {

  final formKey = GlobalKey<FormState>();
  File? _image;

   EmailAuth emailAuth = EmailAuth();
  TextEditingController conEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final txtEmail = TextFormField(
        controller: conEmail,
        decoration: const InputDecoration(
            label: Text('Email User'), enabledBorder: OutlineInputBorder()),
        validator: (value) {
          if (value != null && !EmailValidator.validate(value)) {
            return 'Ingresa un correo valido';
          } else {
            return null;
          }
        });
        
    final spaceHorizontal = SizedBox(
      height: 15,
    );

    final spaceGiant = SizedBox(
      height: 250,
    );

    final btnRecover = ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          emailAuth.sendResetPasswordLink(email: conEmail.text);
          Navigator.pushNamed(context, '/login');
        }
      },
      style: ElevatedButton.styleFrom(
          elevation: 10.0,
          textStyle: const TextStyle(color: Colors.white, fontSize: 20),
          fixedSize: const Size(800, 60)),
      child: const Text('Enviar correo de recuperación'),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    spaceHorizontal,
                    spaceHorizontal,
                    spaceHorizontal,
                    ClipOval(
                      child: _image != null
                          ? Image.file(
                              _image!,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/recuperar.png',
                              width: 150,
                            ),
                    ),
                    spaceHorizontal,
                    spaceHorizontal,
                    txtEmail,
                    spaceHorizontal,
                    spaceHorizontal,
                    spaceHorizontal,
                    btnRecover,
                    spaceGiant
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:proyectofinal_pmsnb/services/email_authentication.dart';
import 'package:proyectofinal_pmsnb/services/post_collection_fb.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  EmailAuth emailAuth = EmailAuth();
  

  PlatformFile? pickedFile;
  UploadTask? uploadTask;
 // PostCollection postCollection = PostCollection();

  Future uploadFirebase() async {

    final urlDownload;
    if (pickedFile == null) {
      urlDownload = await FirebaseStorage.instance
          .ref()
          .child('users/${FirebaseAuth.instance.currentUser!.uid}.png')
          .getDownloadURL();
    } else {
      int cont = 0;
      final storage = FirebaseStorage.instance;
      final reference = storage.ref().child('users');
      final listResult = await reference.listAll();
      cont = listResult.items.length;
      final path = 'users/${FirebaseAuth.instance.currentUser!.uid}.jpg';

      final file = File(pickedFile!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);

      final snapshot = await uploadTask!.whenComplete(() {});

      urlDownload = await snapshot.ref.getDownloadURL();
      print('download link: ${urlDownload}');
    }

    final user = await emailAuth.getUserToken();
  }

  Future selectFile() async {
    final image = await FilePicker.platform.pickFiles();
    if (image == null) return;
    setState(() {
      pickedFile = image.files.first;
    });
    uploadFirebase();
  }

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120),
              child: Stack(
                children: [
                  pickedFile == null ? 
                  user.photoURL != null ? CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(user.photoURL!),
                  ) : CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage("assets/avatar.png"),
                  ) : ClipOval(
                    
                    child: Image.file(
                                      File(pickedFile!.path!),
                                      width: 220,
                                      height: 220,
                                      fit: BoxFit.cover,), 
                  ),
                  ListTile(
                    onTap: () {
                      selectFile();
                    },
                    horizontalTitleGap: 0.0,
                    leading: const Icon(Icons.camera_enhance_outlined),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            
              const SizedBox(
              height: 32,
            ),
            user.displayName != null ? Text(
              'Nombre: ${user.displayName}',
              style: const TextStyle(fontSize: 18),
            ) : Container(),
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

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:proyectofinal_pmsnb/screens/login_screen.dart';
import 'package:proyectofinal_pmsnb/services/firebase_helper.dart';

import '../models/post_model.dart';
import '../services/post_collection_fb.dart';

class PostScreen extends StatefulWidget {
  final String token;
  const PostScreen({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _calController = TextEditingController();
  final _carController = TextEditingController();
  final _descController = TextEditingController();
  final _fatController = TextEditingController();
  final _nameController = TextEditingController();
  final _proController = TextEditingController();
  final _timeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  PostCollection postCollection = PostCollection();

  Future uploadFirebase() async {
    final urlDownload;
    if (pickedFile == null) {
      urlDownload = await FirebaseStorage.instance
          .ref()
          .child('files/platillo.jpg')
          .getDownloadURL();
    } else {
      int cont = 0;
      final storage = FirebaseStorage.instance;
      final reference = storage.ref().child('files');
      final listResult = await reference.listAll();
      cont = listResult.items.length;
      final path = 'files/${cont}.jpg';

      final file = File(pickedFile!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);

      final snapshot = await uploadTask!.whenComplete(() {});

      urlDownload = await snapshot.ref.getDownloadURL();
      print('download link: ${urlDownload}');
    }

    final user = await emailAuth.getUserToken();
    postCollection.insert(
      PostModel(
          caloria: _calController.text,
          carbohidratos: _carController.text,
          descripcion: _descController.text,
          grasas: _fatController.text,
          imagen: urlDownload,
          nombre: _nameController.text,
          proteina: _proController.text,
          tiempo: _timeController.text,
          usuario: user),
    );

    FirebaseHelper.sendNotification(
      title: 'Nueva receta',
      body: _nameController.text,
      token: widget.token,
      image: urlDownload,
    );
  }

  Future selectFile() async {
    final image = await FilePicker.platform.pickFiles();
    if (image == null) return;
    setState(() {
      pickedFile = image.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Icon(Icons.restaurant_menu),
            SizedBox(
              width: 10,
            ),
            Text('Publica tu reseta'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                MyTextField(
                  myController: _nameController,
                  fieldName: "Nombre",
                  myIcon: Icons.food_bank,
                  prefixIconColor: Colors.deepPurple.shade300,
                ),
                MyTextField(
                  myController: _descController,
                  fieldName: "Descripcion",
                  myIcon: Icons.description,
                  prefixIconColor: Colors.deepPurple.shade300,
                ),
                MyTextField(
                  myController: _calController,
                  fieldName: "Calorias",
                  myIcon: Icons.set_meal,
                  prefixIconColor: Colors.deepPurple.shade300,
                  textInputType: TextInputType.number,
                ),
                MyTextField(
                  myController: _carController,
                  fieldName: "Carbohidratos",
                  myIcon: Icons.set_meal,
                  prefixIconColor: Colors.deepPurple.shade300,
                  textInputType: TextInputType.number,
                ),
                MyTextField(
                  myController: _fatController,
                  fieldName: "Grasas",
                  myIcon: Icons.set_meal,
                  prefixIconColor: Colors.deepPurple.shade300,
                  textInputType: TextInputType.number,
                ),
                MyTextField(
                  myController: _proController,
                  fieldName: "Proteinas",
                  myIcon: Icons.set_meal,
                  prefixIconColor: Colors.deepPurple.shade300,
                  textInputType: TextInputType.number,
                ),
                MyTextField(
                  myController: _timeController,
                  fieldName: "Tiempo",
                  myIcon: Icons.timelapse,
                  prefixIconColor: Colors.deepPurple.shade300,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Selecciona una imagen.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: selectFile,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(
                          width: 2, color: Colors.deepPurple.shade500),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(29),
                      ),
                      child: pickedFile != null
                          ? Image.file(
                              File(pickedFile!.path!),
                              width: double.infinity,
                              height: 220,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/platillo.jpg',
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      uploadFirebase();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Publicado'),
                        ),
                      );
                    }
                  },
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  height: 50,
                  color: const Color.fromARGB(255, 59, 160, 255),
                  textColor: Colors.black,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Publicar',
                        style: TextStyle(
                          letterSpacing: 0.8,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.fieldName,
    required this.myController,
    this.myIcon = Icons.verified_user_outlined,
    this.prefixIconColor = Colors.blueAccent,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  final TextEditingController myController;
  final String fieldName;
  final IconData myIcon;
  final Color prefixIconColor;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Requerido';
          } else
            null;
        },
        keyboardType: textInputType,
        controller: myController,
        decoration: InputDecoration(
          labelText: fieldName,
          prefixIcon: Icon(
            myIcon,
            color: prefixIconColor,
          ),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.deepPurple.shade300,
            ),
          ),
          labelStyle: const TextStyle(
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}

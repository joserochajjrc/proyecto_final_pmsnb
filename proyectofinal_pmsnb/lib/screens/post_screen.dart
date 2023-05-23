import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              MyTextField(
                myController: _controller,
                fieldName: "Nombre",
                myIcon: Icons.food_bank,
                prefixIconColor: Colors.deepPurple.shade300,
              ),
              MyTextField(
                myController: _controller,
                fieldName: "Descripcion",
                myIcon: Icons.description,
                prefixIconColor: Colors.deepPurple.shade300,
              ),
              MyTextField(
                myController: _controller,
                fieldName: "Calorias",
                myIcon: Icons.set_meal,
                prefixIconColor: Colors.deepPurple.shade300,
                textInputType: TextInputType.number,
              ),
              MyTextField(
                myController: _controller,
                fieldName: "Carbohidratos",
                myIcon: Icons.set_meal,
                prefixIconColor: Colors.deepPurple.shade300,
                textInputType: TextInputType.number,
              ),
              MyTextField(
                myController: _controller,
                fieldName: "Grasas",
                myIcon: Icons.set_meal,
                prefixIconColor: Colors.deepPurple.shade300,
                textInputType: TextInputType.number,
              ),
              MyTextField(
                myController: _controller,
                fieldName: "Proteinas",
                myIcon: Icons.set_meal,
                prefixIconColor: Colors.deepPurple.shade300,
                textInputType: TextInputType.number,
              ),
              MyTextField(
                myController: _controller,
                fieldName: "Tiempo",
                myIcon: Icons.timelapse,
                prefixIconColor: Colors.deepPurple.shade300,
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Procesando')));
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
                child: Row(
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

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Icon(Icons.star),
            SizedBox(
              width: 10,
            ),
            Text('Suscripciones '),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
                child: const ItemTopic(
                    image: 'assets/postre.jpg', text: 'Postres'),
                onTap: () {}),
            GestureDetector(
                child: const ItemTopic(image: 'assets/pan.jpg', text: 'Panes'),
                onTap: () {}),
            GestureDetector(
                child:
                    const ItemTopic(image: 'assets/guiso.jpg', text: 'Guisos'),
                onTap: () {}),
            GestureDetector(
                child: const ItemTopic(
                    image: 'assets/ensalada.jpg', text: 'Ensaladas'),
                onTap: () {}),
            GestureDetector(
                child:
                    const ItemTopic(image: 'assets/crema.jpg', text: 'Cremas'),
                onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class ItemTopic extends StatelessWidget {
  const ItemTopic({
    super.key,
    required this.image,
    required this.text,
  });
  final String image;
  final String text;

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      width: MediaQuery.of(context).size.width,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: Offset(
              0.0,
              10.0,
            ),
            blurRadius: 10.0,
            spreadRadius: -6.0,
          ),
        ],
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.35),
            BlendMode.multiply,
          ),
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 19,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  height: 50.0,
                  child: MaterialButton(
                    onPressed: () async {
                      await _firebaseMessaging.unsubscribeFromTopic(text);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Suscripcion anulada'),
                        backgroundColor: Colors.redAccent,
                      ));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 66, 66, 66),
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                    color: Colors.black,
                    textColor: Colors.white,
                    child: const Text(
                      'Anular',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  height: 50.0,
                  child: MaterialButton(
                    onPressed: () async {
                      await _firebaseMessaging.subscribeToTopic(text);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Suscrito a: $text'),
                        backgroundColor: Colors.green,
                      ));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    textColor: Colors.black,
                    child: const Text(
                      'Suscribirse',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

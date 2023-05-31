import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:proyectofinal_pmsnb/services/subscriptions_fb.dart';

import '../models/subscription_model.dart';

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

  SubscriptionsCollection subscriptionsCollection = SubscriptionsCollection();
  getSubscriptions() async {
    return await subscriptionsCollection
        .getSubscriptions(FirebaseAuth.instance.currentUser!.uid);
  }

  SubscriptionModel subscriptionModel = SubscriptionModel();

  insSubscriptions() async {
    await subscriptionsCollection.insert(
        SubscriptionModel(
          Cremas: false,
          Ensaladas: false,
          Guisos: false,
          Panes: false,
          Postres: false,
        ),
        FirebaseAuth.instance.currentUser!.uid);
  }

  toogleValue(ValueNotifier<bool> valueNotifier) {
    valueNotifier.value = !valueNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    ValueNotifier<bool> bPostres;
    ValueNotifier<bool> bEnsaladas;
    ValueNotifier<bool> bGuisos;
    ValueNotifier<bool> bPanes;
    ValueNotifier<bool> bCremas;

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
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('suscripciones')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Mientras los datos se están cargando
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              // Si ocurre un error durante la obtención de datos
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              // Si el documento no existe
              insSubscriptions();
              return Container();
            }

            // Si se obtienen los datos exitosamente
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            bCremas = ValueNotifier<bool>(data['Cremas']);
            bPanes = ValueNotifier<bool>(data['Panes']);
            bGuisos = ValueNotifier<bool>(data['Guisos']);
            bPostres = ValueNotifier<bool>(data['Postres']);
            bEnsaladas = ValueNotifier<bool>(data['Ensaladas']);

            return Column(
              children: [
                ItemNoti(
                  context,
                  _firebaseMessaging,
                  bEnsaladas,
                  'Ensaladas',
                  'assets/ensalada.jpg',
                ),
                ItemNoti(
                  context,
                  _firebaseMessaging,
                  bGuisos,
                  'Guisos',
                  'assets/guiso.jpg',
                ),
                ItemNoti(
                  context,
                  _firebaseMessaging,
                  bPanes,
                  'Panes',
                  'assets/pan.jpg',
                ),
                ItemNoti(
                  context,
                  _firebaseMessaging,
                  bPostres,
                  'Postres',
                  'assets/postre.jpg',
                ),
                ItemNoti(
                  context,
                  _firebaseMessaging,
                  bCremas,
                  'Cremas',
                  'assets/crema.jpg',
                ),
              ],
            );
          },
        ),
        ///////////////////////
      ),
    );
  }

  Container ItemNoti(BuildContext context, FirebaseMessaging _firebaseMessaging,
      ValueNotifier<bool> isActive, String text, String image) {
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
                ValueListenableBuilder<bool>(
                  valueListenable: isActive,
                  builder: (BuildContext context, bool value, Widget? child) {
                    if (value) {
                      return Container(
                        margin: EdgeInsets.all(10),
                        height: 50.0,
                        width: 150,
                        child: MaterialButton(
                          onPressed: () async {
                            await _firebaseMessaging.unsubscribeFromTopic(text);
                            FirebaseFirestore.instance
                                .collection('suscripciones')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({
                              text: false,
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Suscripcion anulada'),
                              backgroundColor: Colors.redAccent,
                            ));
                            toogleValue(isActive);
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
                      );
                    } else {
                      return Container(
                        margin: EdgeInsets.all(10),
                        height: 50.0,
                        width: 150,
                        child: MaterialButton(
                          onPressed: () async {
                            await _firebaseMessaging.subscribeToTopic(text);
                            FirebaseFirestore.instance
                                .collection('suscripciones')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({
                              text: true,
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Suscrito a: $text'),
                              backgroundColor: Colors.green,
                            ));
                            toogleValue(isActive);
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
                      );
                    }
                  },
                )
              ],
            ),
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
    required this.isActive,
  });
  final String image;
  final String text;
  final bool isActive;

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
                isActive
                    ? Container(
                        margin: EdgeInsets.all(10),
                        height: 50.0,
                        width: 150,
                        child: MaterialButton(
                          onPressed: () async {
                            await _firebaseMessaging.unsubscribeFromTopic(text);
                            FirebaseFirestore.instance
                                .collection('suscripciones')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({
                              text: false,
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
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
                      )
                    : Container(
                        margin: EdgeInsets.all(10),
                        height: 50.0,
                        width: 150,
                        child: MaterialButton(
                          onPressed: () async {
                            await _firebaseMessaging.subscribeToTopic(text);
                            FirebaseFirestore.instance
                                .collection('suscripciones')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({
                              text: true,
                            });
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
